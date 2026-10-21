import 'package:fl_clash/xboard/config/parsers/configuration_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConfigurationParseException', () {
    test('renders the message and keeps the original error', () {
      final exception = ConfigurationParseException(
        'boom',
        const FormatException('x'),
      );
      expect(exception.message, 'boom');
      expect(exception.originalError, isA<FormatException>());
      expect(exception.toString(), 'ConfigurationParseException: boom');
    });
  });

  group('ValidationError', () {
    test('toString exposes field, message and type', () {
      const error = ValidationError(
        field: 'proxy[0].url',
        message: 'missing',
        type: ValidationErrorType.missingField,
      );
      expect(
        error.toString(),
        'ValidationError(field: proxy[0].url, message: missing, type: ValidationErrorType.missingField)',
      );
    });
  });

  group('ConfigValidator', () {
    final validator = ConfigValidator();

    test('rejects config without any recognized section', () {
      expect(validator.validateConfiguration(const {}), isFalse);
      final errors = validator.getValidationErrors(const {});
      expect(errors.single.field, 'root');
      expect(errors.single.type, ValidationErrorType.missingField);
    });

    test('accepts a minimal subscription config', () {
      expect(
        validator.validateConfiguration(const {
          'subscription': {'urls': []},
        }),
        isTrue,
      );
    });

    test('rejects non-map panels', () {
      final errors = validator.getValidationErrors(const {'panels': []});
      expect(errors.single.field, 'panels');
      expect(errors.single.type, ValidationErrorType.invalidType);
    });

    test('reports panel items that are not objects', () {
      final errors = validator.getValidationErrors(const {
        'panels': {
          'Flclash': ['oops'],
        },
      });
      expect(errors.single.field, 'panels.Flclash[0]');
    });

    test('requires url and description on panel items', () {
      final errors = validator.getValidationErrors(const {
        'panels': {
          'Flclash': [
            {'url': 123, 'description': 'ok'},
          ],
        },
      });
      expect(errors.map((e) => e.field), contains('panels.Flclash[0].url'));
    });

    test('reports provider whose value is not a list', () {
      final errors = validator.getValidationErrors(const {
        'panels': {'Flclash': 'nope'},
      });
      expect(errors.single.field, 'panels.Flclash');
    });

    test('validates service lists and requires protocol for proxy', () {
      final errors = validator.getValidationErrors(const {
        'proxy': [
          {'url': 'http://p', 'description': 'd'},
        ],
      });
      expect(errors.single.field, 'proxy[0].protocol');
    });

    test('rejects a non-list service list', () {
      final errors = validator.getValidationErrors(const {'proxy': 'nope'});
      expect(errors.single.field, 'proxy');
      expect(errors.single.type, ValidationErrorType.invalidType);
    });

    test('flags service items that are not objects', () {
      final errors = validator.getValidationErrors(const {
        'proxy': ['nope'],
      });
      expect(errors.single.field, 'proxy[0]');
    });

    test('requires description on a service item', () {
      final errors = validator.getValidationErrors(const {
        'proxy': [
          {'url': 'http://p', 'protocol': 'http'},
        ],
      });
      expect(errors.map((e) => e.field), contains('proxy[0].description'));
    });

    // ws/update/onlineSupport 已下线，但线上配置可能还在下发；
    // 只带这些段落的配置应当继续被接受（内容忽略），而不是整份判死。
    test('tolerates retired sections', () {
      expect(
        validator.validateConfiguration(const {
          'ws': [
            {'url': 'wss://a', 'description': 'd'},
          ],
          'update': 'not-even-a-list',
          'onlineSupport': {'shape': 'anything'},
        }),
        isTrue,
      );
    });

    test('rejects a subscription that is not an object', () {
      final errors = validator.getValidationErrors(const {
        'subscription': 'nope',
      });
      expect(errors.single.field, 'subscription');
      expect(errors.single.type, ValidationErrorType.invalidType);
    });
  });

  group('ConfigurationParser.parseFromJson', () {
    final parser = ConfigurationParser();

    test('parses a valid config', () {
      final config = parser.parseFromJson(const {
        'panelType': 'xboard',
        'panels': {
          'Flclash': [
            {'url': 'https://p', 'description': 'd'},
          ],
        },
      }, 'Flclash');
      expect(config.panelType, 'xboard');
      expect(config.panels.firstUrl, 'https://p');
    });

    test('wraps validation failures in ConfigurationParseException', () {
      expect(
        () => parser.parseFromJson(const {}, 'Flclash'),
        throwsA(isA<ConfigurationParseException>()),
      );
    });

    test('wraps unexpected parse errors', () {
      expect(
        () => parser.parseFromJson(const {
          'panelType': 'xboard',
          'panels': {
            'Flclash': [
              {'url': 'x', 'description': 'y'},
            ],
          },
          'proxy': [42],
        }, 'Flclash'),
        throwsA(isA<ConfigurationParseException>()),
      );
    });
  });

  group('ConfigurationParser.parseFromMultipleSources', () {
    final parser = ConfigurationParser();

    test('throws when there are no configs', () {
      expect(
        () => parser.parseFromMultipleSources(const [], 'Flclash'),
        throwsA(isA<ConfigurationParseException>()),
      );
    });

    test('delegates to single-config parse', () {
      final config = parser.parseFromMultipleSources(const [
        {
          'panelType': 'xboard',
          'panels': {
            'Flclash': [
              {'url': 'https://p', 'description': 'd'},
            ],
          },
        },
      ], 'Flclash');
      expect(config.firstPanelUrl, 'https://p');
    });

    // `_mergeConfigurations` merges panels/service lists/subscriptions but never
    // copies `panelType`, so the merged document fails the required-field check.
    // The merge loop itself still runs (that is what this covers).
    test('runs the merge and then fails on the dropped panelType', () {
      expect(
        () => parser.parseFromMultipleSources(const [
          {
            'panelType': 'xboard',
            'panels': {
              'Flclash': [
                {'url': 'https://a', 'description': 'a'},
              ],
            },
            'proxy': [
              {'url': 'http://p1', 'description': '1', 'protocol': 'http'},
            ],
            'subscription': {
              'urls': [
                {'url': 'https://s1'},
              ],
            },
            'metadata': {
              'sources': ['x'],
            },
          },
          {
            'panelType': 'xboard',
            'panels': {
              'Flclash': [
                {'url': 'https://b', 'description': 'b'},
              ],
            },
            'proxy': [
              {'url': 'http://p2', 'description': '2', 'protocol': 'http'},
            ],
            'subscription': {
              'urls': [
                {'url': 'https://s2'},
              ],
            },
          },
        ], 'Flclash'),
        throwsA(isA<ConfigurationParseException>()),
      );
    });

    test('skips invalid configs while merging', () {
      expect(
        () => parser.parseFromMultipleSources(const [
          {
            'panelType': 'xboard',
            'panels': {
              'Flclash': [
                {'url': 'https://a', 'description': 'a'},
              ],
            },
          },
          {'bogus': 'value'}, // invalid: no recognized section
        ], 'Flclash'),
        throwsA(isA<ConfigurationParseException>()),
      );
    });
  });

  group('ConfigurationParser.extractConfigFromRemoteResult', () {
    final parser = ConfigurationParser();

    test('returns the input when it already has a known section', () {
      const input = {'panels': {}};
      expect(parser.extractConfigFromRemoteResult(input), same(input));
    });

    test('passes through a result that already carries proxy/ws/etc keys', () {
      const input = {'proxy': [], 'ws': []};
      expect(parser.extractConfigFromRemoteResult(input), same(input));
    });

    test('converts legacy panel_urls into panels', () {
      final result = parser.extractConfigFromRemoteResult(const {
        'panel_urls': ['https://a', 'https://b'],
      });
      expect(result, isNotNull);
      final panels = result!['panels'] as Map<String, dynamic>;
      expect((panels['Flclash'] as List).length, 2);
      expect((panels['Flclash'] as List).first, {
        'url': 'https://a',
        'description': '从旧格式转换的面板URL',
      });
    });

    test('returns null when nothing recognizable is present', () {
      expect(
        parser.extractConfigFromRemoteResult(const {'foo': 'bar'}),
        isNull,
      );
    });

    test('returns null when panel_urls is null', () {
      expect(
        parser.extractConfigFromRemoteResult(const {'panel_urls': null}),
        isNull,
      );
    });
  });
}
