import 'dart:async';
import 'dart:io';

import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/xboard/utils/xboard_core_validation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;

import '../helpers/app_paths.dart';

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

  late _MockCoreInterface coreInterface;
  late CoreController core;
  late Directory root;
  late Directory home;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('xboard_validation_');
    addTearDown(() => root.delete(recursive: true));
    home = await useAppPaths(root);
    coreInterface = _MockCoreInterface();
    core = CoreController.scoped(coreInterface);
  });

  group('iOS 共享校验文件', () {
    test('数据在共享目录中保持完整，成功后清理', () async {
      const content = '$_clashConfig# 订阅配置\r\n';
      late String sharedPath;
      when(() => coreInterface.validateConfig(any())).thenAnswer((call) async {
        sharedPath = call.positionalArguments.single as String;
        expect(p.isWithin(home.path, sharedPath), isTrue);
        expect(await File(sharedPath).readAsString(), content);
        return '';
      });

      expect(
        await xboardValidateConfigDataWith(
          content,
          core: core,
          reachable: () async => true,
          isIOS: true,
        ),
        isEmpty,
      );
      expect(await File(sharedPath).parent.exists(), isFalse);
    });

    test('文件副本交给 Core，保留原始文件', () async {
      final source = File(p.join(root.path, 'download.yaml'));
      await source.writeAsString(_clashConfig);
      late String sharedPath;
      when(() => coreInterface.validateConfig(any())).thenAnswer((call) async {
        sharedPath = call.positionalArguments.single as String;
        expect(sharedPath, isNot(source.path));
        expect(p.isWithin(home.path, sharedPath), isTrue);
        expect(await File(sharedPath).readAsString(), _clashConfig);
        return '';
      });

      expect(
        await xboardValidateProfileWith(
          source.path,
          '',
          core: core,
          reachable: () async => true,
          isIOS: true,
        ),
        isEmpty,
      );
      expect(await source.readAsString(), _clashConfig);
      expect(await File(sharedPath).parent.exists(), isFalse);
    });

    test('Core 拒绝时原样返回错误并清理共享副本', () async {
      late String sharedPath;
      when(() => coreInterface.validateConfig(any())).thenAnswer((call) async {
        sharedPath = call.positionalArguments.single as String;
        return 'unsupported proxy type';
      });

      expect(
        await xboardValidateConfigDataWith(
          _clashConfig,
          core: core,
          reachable: () async => true,
          isIOS: true,
        ),
        'unsupported proxy type',
      );
      expect(await File(sharedPath).parent.exists(), isFalse);
    });

    test('Core 抛出异常时保留原文件并清理共享副本', () async {
      final source = File(p.join(root.path, 'download.yaml'));
      await source.writeAsString(_clashConfig);
      final error = StateError('Core unavailable');
      late String sharedPath;
      when(() => coreInterface.validateConfig(any())).thenAnswer((call) async {
        sharedPath = call.positionalArguments.single as String;
        throw error;
      });

      await expectLater(
        xboardValidateProfileWith(
          source.path,
          '',
          core: core,
          reachable: () async => true,
          isIOS: true,
        ),
        throwsA(same(error)),
      );
      expect(await source.readAsString(), _clashConfig);
      expect(await File(sharedPath).parent.exists(), isFalse);
    });

    test('并发校验使用独立文件且互不覆盖', () async {
      final paths = <String>[];
      final contents = <String>[];
      final entered = Completer<void>();
      final release = Completer<void>();
      when(() => coreInterface.validateConfig(any())).thenAnswer((call) async {
        final path = call.positionalArguments.single as String;
        paths.add(path);
        contents.add(await File(path).readAsString());
        if (contents.length == 2) entered.complete();
        await release.future;
        expect(await File(path).exists(), isTrue);
        return '';
      });

      final validations = [
        for (final name in ['first', 'second'])
          xboardValidateConfigDataWith(
            '$_clashConfig# $name\n',
            core: core,
            reachable: () async => true,
            isIOS: true,
          ),
      ];
      try {
        await entered.future;
        expect(paths.toSet(), hasLength(2));
        expect(
          contents,
          unorderedEquals([
            '$_clashConfig# first\n',
            '$_clashConfig# second\n',
          ]),
        );
      } finally {
        release.complete();
        await Future.wait(validations);
      }
      for (final path in paths) {
        expect(await File(path).parent.exists(), isFalse);
      }
    });

    test('age 解密仅访问共享文件，成功内容复制回原文件', () async {
      final source = File(p.join(root.path, 'encrypted.yaml'));
      await source.writeAsString(
        '-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24\n'
        '-----END AGE ENCRYPTED FILE-----',
      );
      late String sharedPath;
      when(() => coreInterface.decryptConfig(any(), any())).thenAnswer((
        call,
      ) async {
        sharedPath = call.positionalArguments.first as String;
        expect(p.isWithin(home.path, sharedPath), isTrue);
        expect(sharedPath, isNot(source.path));
        expect(
          await File(sharedPath).readAsString(),
          await source.readAsString(),
        );
        return _clashConfig;
      });
      when(() => coreInterface.validateConfig(any())).thenAnswer((call) async {
        expect(call.positionalArguments.single, sharedPath);
        expect(await File(sharedPath).readAsString(), _clashConfig);
        return '';
      });

      expect(
        await xboardValidateProfileWith(
          source.path,
          'AGE-SECRET-KEY-1',
          core: core,
          reachable: () => throw StateError('age must use Core'),
          isIOS: true,
        ),
        isEmpty,
      );
      expect(await source.readAsString(), _clashConfig);
      expect(await File(sharedPath).parent.exists(), isFalse);
    });
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
      final file = File(p.join(root.path, 'valid.yaml'));

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
      final file = File(p.join(root.path, 'invalid.yaml'));

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
      final file = File(p.join(root.path, 'encrypted.yaml'));
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
