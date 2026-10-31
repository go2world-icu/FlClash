import 'dart:async';

import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/config/internal/xboard_config_accessor.dart';
import 'package:fl_clash/xboard/config/parsers/configuration_parser.dart';
import 'package:flutter_test/flutter_test.dart';

const _configuration = <String, dynamic>{
  'panelType': 'xboard',
  'panels': {
    'test': [
      {'url': 'https://panel.invalid', 'description': 'test'},
    ],
  },
};

class _Source implements ConfigSource {
  _Source(this.sourceName, this.fetch);

  @override
  final String sourceName;
  final Future<ConfigResult<Map<String, dynamic>>> Function() fetch;
  int calls = 0;

  @override
  int get priority => 0;

  @override
  Future<ConfigResult<Map<String, dynamic>>> fetchConfig() {
    calls++;
    return fetch();
  }
}

XBoardConfigAccessor _accessor(List<ConfigSource> sources) {
  final accessor = XBoardConfigAccessor(
    remoteManager: RemoteConfigManager(sources: sources, maxRetries: 0),
    parser: ConfigurationParser(),
    currentProvider: 'test',
  );
  addTearDown(accessor.dispose);
  return accessor;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'first usable source wins without waiting for a slower failure',
    () async {
      final fast = Completer<ConfigResult<Map<String, dynamic>>>();
      final slow = Completer<ConfigResult<Map<String, dynamic>>>();
      final redirect = _Source('redirect', () => fast.future);
      final gitee = _Source('gitee', () => slow.future);
      final accessor = _accessor([redirect, gitee]);
      final pending = accessor.refreshConfiguration();
      await Future<void>.delayed(Duration.zero);
      expect(redirect.calls, 1);
      expect(gitee.calls, 1);

      fast.complete(ConfigResult.success(_configuration, 'redirect'));
      await pending;
      expect(accessor.state, ConfigAccessorState.ready);
      expect(accessor.getFirstPanelUrl(), 'https://panel.invalid');

      slow.complete(ConfigResult.failure('late timeout', 'gitee'));
      await Future<void>.delayed(Duration.zero);
      expect(accessor.state, ConfigAccessorState.ready);
      expect(accessor.lastError, isNull);
    },
  );

  test('a malformed source does not beat a later valid source', () async {
    final valid = Completer<ConfigResult<Map<String, dynamic>>>();
    final accessor = _accessor([
      _Source(
        'redirect',
        () async => ConfigResult.success(const {
          'panels': {'test': <Object>[]},
        }, 'redirect'),
      ),
      _Source('gitee', () => valid.future),
    ]);
    final pending = accessor.refreshConfiguration();
    await Future<void>.delayed(Duration.zero);
    expect(accessor.state, ConfigAccessorState.loading);
    valid.complete(ConfigResult.success(_configuration, 'gitee'));
    await pending;
    expect(accessor.state, ConfigAccessorState.ready);
    expect(accessor.lastError, isNull);
  });

  test(
    'an unregistered fallback does not hide the registered source error',
    () async {
      final accessor = _accessor([
        _Source(
          'redirect',
          () async => ConfigResult.failure('connection timed out', 'redirect'),
        ),
      ]);
      await accessor.refreshConfiguration();
      expect(accessor.state, ConfigAccessorState.error);
      expect(accessor.lastError, contains('redirect:'));
      expect(accessor.lastError, contains('connection timed out'));
      expect(accessor.lastError, isNot(contains('gitee')));
    },
  );

  test('all failures retain source and schema diagnostics', () async {
    final accessor = _accessor([
      _Source(
        'redirect',
        () async => ConfigResult.failure('HTTP 403', 'redirect'),
      ),
      _Source(
        'gitee',
        () async => ConfigResult.success(const {
          'panels': {'test': <Object>[]},
        }, 'gitee'),
      ),
    ]);
    await accessor.refreshConfiguration();
    expect(accessor.lastError, contains('redirect:'));
    expect(accessor.lastError, contains('HTTP 403'));
    expect(accessor.lastError, contains('gitee:'));
    expect(accessor.lastError, contains('panelType is required'));
  });

  test('a failed refresh leaves a cached configuration ready', () async {
    final accessor = _accessor([
      _Source(
        'redirect',
        () async => ConfigResult.failure('offline', 'redirect'),
      ),
    ]);
    expect(await accessor.loadCachedConfiguration(_configuration), isTrue);
    await accessor.refreshConfiguration();
    expect(accessor.state, ConfigAccessorState.ready);
    expect(accessor.getFirstPanelUrl(), 'https://panel.invalid');
    expect(accessor.lastError, contains('offline'));
  });

  test('diagnostics omit signed URLs and raw response excerpts', () async {
    final accessor = _accessor([
      _Source(
        'redirect',
        () async => ConfigResult.failure(
          'HTTP 403 at https://user:secret@config.invalid/private?sign=key '
              'token=private-token\n{"password":"raw-response-secret"}',
          'redirect',
        ),
      ),
    ]);
    await accessor.refreshFromSource('redirect');
    expect(accessor.lastError, contains('HTTP 403'));
    for (final secret in [
      'user:',
      'secret',
      '/private',
      'sign=',
      'private-token',
      'raw-response',
    ]) {
      expect(accessor.lastError, isNot(contains(secret)));
    }
  });

  test('thrown request failures retain their source name', () async {
    final accessor = _accessor([
      _Source('redirect', () => throw StateError('physical route unavailable')),
    ]);
    await accessor.refreshConfiguration();
    expect(accessor.lastError, contains('redirect:'));
    expect(accessor.lastError, contains('physical route unavailable'));
  });

  test('an empty source list reports a configuration problem', () async {
    final accessor = _accessor([]);
    await accessor.refreshConfiguration();
    expect(
      accessor.lastError,
      contains('No remote panel configuration sources registered'),
    );
  });
}
