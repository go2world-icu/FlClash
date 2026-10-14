import 'package:fl_clash/xboard/core/exceptions/xboard_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('XBoardException', () {
    test('toString includes code and optional detail blocks', () {
      final plain = XBoardException(code: 'C', message: 'm');
      expect(plain.toString(), 'XBoardException(C: m)');

      final rich = XBoardException(
        code: 'C',
        message: 'm',
        details: const {'k': 'v'},
        originalError: 'orig',
      );
      final text = rich.toString();
      expect(text, contains('Details: {k: v}'));
      expect(text, contains('Original: orig'));
    });

    test('equality is based on code and message', () {
      final a = XBoardException(code: 'C', message: 'm');
      final b = XBoardException(code: 'C', message: 'm', details: const {'x': 1});
      final c = XBoardException(code: 'D', message: 'm');
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(c));
    });
  });

  group('subtype rendering', () {
    test('network exception renders status and url', () {
      final e = XBoardNetworkException(
        message: 'm',
        statusCode: 500,
        url: 'https://u',
        details: const {'k': 1},
      );
      final text = e.toString();
      expect(e.code, 'NETWORK_ERROR');
      expect(text, contains('Status: 500'));
      expect(text, contains('URL: https://u'));
      expect(text, contains('Details'));
    });

    test('auth exception renders', () {
      expect(
        XBoardAuthException(message: 'm').toString(),
        'XBoardAuthException(AUTH_ERROR: m)',
      );
    });

    test('validation exception renders the field', () {
      final text = XBoardValidationException(message: 'm', field: 'email').toString();
      expect(text, contains('Field: email'));
    });

    test('business exception renders', () {
      expect(
        XBoardBusinessException(code: 'B', message: 'm').toString(),
        'XBoardBusinessException(B: m)',
      );
    });

    test('parse exception renders the data type', () {
      final text = XBoardParseException(message: 'm', dataType: 'User').toString();
      expect(text, contains('DataType: User'));
    });

    test('storage exception renders operation and key', () {
      final text = XBoardStorageException(
        message: 'm',
        operation: 'write',
        key: 'k',
      ).toString();
      expect(text, contains('Operation: write'));
      expect(text, contains('Key: k'));
    });

    test('config exception renders', () {
      expect(
        XBoardConfigException(message: 'm').toString(),
        'XBoardConfigException(CONFIG_ERROR: m)',
      );
    });

    test('timeout exception renders the timeout', () {
      final text = XBoardTimeoutException(message: 'm', timeoutMs: 5000).toString();
      expect(text, contains('Timeout: 5000ms'));
    });

    test('unknown exception has defaults', () {
      final e = XBoardUnknownException();
      expect(e.code, 'UNKNOWN_ERROR');
      expect(e.message, '未知错误');
      expect(e.toString(), 'XBoardUnknownException(UNKNOWN_ERROR: 未知错误)');
    });
  });

  group('XBoardErrorCodes', () {
    test('exposes the documented codes', () {
      expect(XBoardErrorCodes.unknown, 'UNKNOWN_ERROR');
      expect(XBoardErrorCodes.unauthorized, 'UNAUTHORIZED');
      expect(XBoardErrorCodes.tokenExpired, 'TOKEN_EXPIRED');
      expect(XBoardErrorCodes.storageWriteError, 'STORAGE_WRITE_ERROR');
      expect(XBoardErrorCodes.configNotInitialized, 'CONFIG_NOT_INITIALIZED');
    });
  });
}
