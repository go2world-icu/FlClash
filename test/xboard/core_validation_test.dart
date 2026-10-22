import 'dart:io';

import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/xboard/utils/xboard_core_validation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCoreInterface extends Mock implements CoreHandlerInterface {}

const _clashConfig = '''
mixed-port: 7890
proxies:
  - name: hk
    type: ss
    server: 1.2.3.4
    port: 443
    cipher: aes-256-gcm
    password: secret
proxy-groups:
  - name: PROXY
    type: select
    proxies: [hk]
''';

/// iOS 的 core 藏在 PacketTunnel 里，隧道没开时问不到——面板导入订阅恰恰发生在
/// 隧道没开的时候。这一组用例钉住两侧行为：可达时仍以 core 为准；不可达时先存，
/// 不等 core 也不假装校验过。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // `validateConfigWithData` 先把内容写进一个临时文件；测试里没有平台侧
  // path_provider，直接回一个临时目录。
  setUpAll(() {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    for (final channel in const [
      'plugins.flutter.io/path_provider',
      'plugins.flutter.io/path_provider_macos',
      'plugins.flutter.io/path_provider_windows',
      'plugins.flutter.io/path_provider_linux',
    ]) {
      messenger.setMockMethodCallHandler(
        MethodChannel(channel),
        (call) async =>
            call.method == 'getApplicationSupportDirectory' ||
                call.method == 'getApplicationDocumentsDirectory'
            ? Directory('${Directory.systemTemp.path}/fl_clash_test').path
            : Directory.systemTemp.path,
      );
    }
  });

  late _MockCoreInterface coreInterface;
  late CoreController core;

  setUp(() {
    coreInterface = _MockCoreInterface();
    core = CoreController.scoped(coreInterface);
  });

  group('core 可达时', () {
    setUp(() {
      when(
        () => coreInterface.validateConfig(any()),
      ).thenAnswer((_) async => '');
    });

    test('校验交给 core，本地检查不插手', () async {
      // 本地检查会判它不合格（没有 proxies），core 说合格就是合格。
      final message = await xboardValidateConfigDataWith(
        'mixed-port: 7890',
        core: core,
        reachable: () async => true,
      );

      expect(message, isEmpty);
      verify(() => coreInterface.validateConfig(any())).called(1);
    });

    test('core 的拒绝原样返回', () async {
      when(
        () => coreInterface.validateConfig(any()),
      ).thenAnswer((_) async => 'unsupport proxy type');

      final message = await xboardValidateConfigDataWith(
        _clashConfig,
        core: core,
        reachable: () async => true,
      );

      expect(message, 'unsupport proxy type');
    });
  });

  group('core 不可达时', () {
    test('不碰 core，合格的内容放行', () async {
      final file = File(
        '${Directory.systemTemp.path}/xboard_core_validation_ok.yaml',
      );
      addTearDown(() => file.deleteSync());

      final message = await xboardValidateProfileWith(
        (file..writeAsStringSync(_clashConfig)).path,
        '',
        core: core,
        reachable: () async => false,
      );

      expect(message, isEmpty);
      verifyNever(() => coreInterface.validateConfig(any()));
      verifyNever(() => coreInterface.convertProxies(any()));
    });

    test('不合格的内容照样拒绝，而不是一律放行', () async {
      final file = File(
        '${Directory.systemTemp.path}/xboard_core_validation_bad.yaml',
      );
      addTearDown(() => file.deleteSync());

      final message = await xboardValidateProfileWith(
        (file..writeAsStringSync('mixed-port: 7890\n')).path,
        '',
        core: core,
        reachable: () async => false,
      );

      expect(message, isNotEmpty);
      verifyNever(() => coreInterface.validateConfig(any()));
    });

    test('带 age 密钥时仍然走 core：解密只有它做得了', () async {
      when(
        () => coreInterface.decryptConfig(any(), any()),
      ).thenAnswer((_) async => _clashConfig);
      when(
        () => coreInterface.validateConfig(any()),
      ).thenAnswer((_) async => '');
      final file = File(
        '${Directory.systemTemp.path}/xboard_core_validation_age.yaml',
      );
      addTearDown(() => file.deleteSync());
      await file.writeAsString(
        '-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24\n'
        '-----END AGE ENCRYPTED FILE-----',
      );

      await xboardValidateProfileWith(
        file.path,
        'AGE-SECRET-KEY-1',
        core: core,
        reachable: () async => false,
      );

      verify(
        () => coreInterface.decryptConfig(any(), 'AGE-SECRET-KEY-1'),
      ).called(1);
    });
  });

  group('本地结构校验', () {
    test('有 proxies 的 Clash 配置通过', () {
      expect(xboardValidateConfigContent(_clashConfig), isEmpty);
    });

    test('只有 proxy-providers 也通过', () {
      expect(
        xboardValidateConfigContent(
          'proxy-providers:\n  p:\n    type: http\n    url: https://x\n',
        ),
        isEmpty,
      );
    });

    test('空 proxies 且没有 providers 时拒绝', () {
      expect(xboardValidateConfigContent('proxies: []\n'), contains('没有节点'));
    });

    test('两个段落都没有时拒绝', () {
      expect(
        xboardValidateConfigContent('mixed-port: 7890\n'),
        contains('proxies'),
      );
    });

    test('不是 YAML 时拒绝', () {
      expect(xboardValidateConfigContent('{"proxies": [}\n'), contains('YAML'));
    });

    test('纯文本（HTML 错误页、空回复）时拒绝', () {
      expect(
        xboardValidateConfigContent('<html>502 Bad Gateway</html>'),
        contains('YAML 映射'),
      );
      expect(xboardValidateConfigContent(''), contains('YAML 映射'));
    });

    test('面板自己的远程配置不会被当成订阅收下', () {
      expect(
        xboardValidateConfigContent(
          'panels:\n  Flclash:\n    - url: https://x\ndescription: hi\n',
        ),
        contains('面板配置'),
      );
    });
  });
}
