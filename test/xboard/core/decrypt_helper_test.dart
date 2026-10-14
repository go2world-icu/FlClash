import 'dart:convert';
import 'dart:typed_data';

import 'package:fl_clash/xboard/core/utils/xboard_decrypt_helper.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reproduces the encryption the helper expects to undo:
/// xor(utf8(base64(utf8(plaintext))), key) then base64 for transport.
String _encrypt(String plaintext, String key) {
  final inner = base64.encode(utf8.encode(plaintext));
  final xored = XBoardDecryptHelper.xorDecrypt(
    Uint8List.fromList(utf8.encode(inner)),
    key,
  );
  return base64.encode(xored);
}

void main() {
  const key = 'secret-key';
  const clashConfig =
      'port: 7890\nproxies:\n  - name: node\nrules:\n  - DOMAIN,x,node';

  group('xorDecrypt', () {
    test('is its own inverse', () {
      final data = Uint8List.fromList(utf8.encode('hello world'));
      final once = XBoardDecryptHelper.xorDecrypt(data, key);
      final twice = XBoardDecryptHelper.xorDecrypt(once, key);
      expect(twice, data);
    });
  });

  group('decryptXBoard', () {
    test('recovers the original plaintext', () {
      final encrypted = _encrypt(clashConfig, key);
      expect(
        XBoardDecryptHelper.decryptXBoard(encrypted, key: key),
        clashConfig,
      );
    });

    test('unwraps an extra base64 layer when present', () {
      final doubleEncoded = base64.encode(utf8.encode(clashConfig));
      final encrypted = _encrypt(doubleEncoded, key);
      expect(
        XBoardDecryptHelper.decryptXBoard(encrypted, key: key),
        clashConfig,
      );
    });

    test('returns an error string for garbage input', () {
      expect(
        XBoardDecryptHelper.decryptXBoard('not base64!!', key: key),
        startsWith('解密失败'),
      );
    });

    test('returns an error string with the wrong key', () {
      final encrypted = _encrypt(clashConfig, key);
      final result = XBoardDecryptHelper.decryptXBoard(encrypted, key: 'wrong');
      // Wrong key produces either a decode failure or mojibake, never the config.
      expect(result, isNot(clashConfig));
    });
  });

  group('isValidClashConfig', () {
    test('accepts proxies/rules markers', () {
      expect(XBoardDecryptHelper.isValidClashConfig(clashConfig), isTrue);
      expect(XBoardDecryptHelper.isValidClashConfig('- name: a'), isTrue);
      expect(XBoardDecryptHelper.isValidClashConfig('- DOMAIN,x,y'), isTrue);
      expect(XBoardDecryptHelper.isValidClashConfig('port: 8080'), isTrue);
    });

    test('rejects unrelated text', () {
      expect(XBoardDecryptHelper.isValidClashConfig('hello world'), isFalse);
    });
  });

  group('decryptWithMultipleKeys', () {
    test('returns the plaintext when a key matches', () {
      final encrypted = _encrypt(clashConfig, 'second');
      expect(
        XBoardDecryptHelper.decryptWithMultipleKeys(encrypted, [
          'first',
          'second',
        ]),
        clashConfig,
      );
    });

    test('reports failure when no key matches', () {
      final encrypted = _encrypt(clashConfig, 'real');
      expect(
        XBoardDecryptHelper.decryptWithMultipleKeys(encrypted, ['a', 'b']),
        '所有密钥都无法成功解密',
      );
    });
  });

  group('getFallbackKeys', () {
    test('returns a non-empty list', () {
      expect(XBoardDecryptHelper.getFallbackKeys(), isNotEmpty);
    });
  });

  group('smartDecrypt', () {
    test('succeeds with the configured key', () {
      final encrypted = _encrypt(clashConfig, key);
      final result = XBoardDecryptHelper.smartDecrypt(
        encrypted,
        configuredKey: key,
      );
      expect(result.success, isTrue);
      expect(result.content, clashConfig);
      expect(result.keyUsed, key);
      expect(result.keyIndex, 0);
      expect(result.message, '使用配置密钥解密成功');
      expect(result.toString(), contains('success: true'));
    });

    test('falls back to a fallback key when enabled', () {
      final fallback = XBoardDecryptHelper.getFallbackKeys().first;
      final encrypted = _encrypt(clashConfig, fallback);
      final result = XBoardDecryptHelper.smartDecrypt(
        encrypted,
        configuredKey: 'nope',
        tryFallback: true,
      );
      expect(result.success, isTrue);
      expect(result.keyUsed, fallback);
      expect(result.message, '使用备用密钥解密成功');
    });

    test('reports failure without a matching key', () {
      final encrypted = _encrypt(clashConfig, 'real');
      final result = XBoardDecryptHelper.smartDecrypt(
        encrypted,
        configuredKey: 'nope',
      );
      expect(result.success, isFalse);
      expect(result.content, '');
      expect(result.keyUsed, isNull);
      expect(result.keyIndex, -1);
      expect(result.message, '配置密钥解密失败');
    });

    test('reports the exhausted-fallback message', () {
      final encrypted = _encrypt(clashConfig, 'real');
      final result = XBoardDecryptHelper.smartDecrypt(
        encrypted,
        configuredKey: 'nope',
        tryFallback: true,
      );
      expect(result.success, isFalse);
      expect(result.message, '所有解密方式都失败了');
    });
  });
}
