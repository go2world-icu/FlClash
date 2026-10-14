import 'package:fl_clash/xboard/core/result/result.dart';
import 'package:fl_clash/xboard/core/exceptions/xboard_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final error = XBoardException(code: 'E', message: 'boom');

  group('Result', () {
    test('success exposes data and reports state', () {
      final result = Result<int>.success(3);
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.dataOrNull, 3);
      expect(result.data, 3);
      expect(result.exceptionOrNull, isNull);
    });

    test('failure exposes the exception and reports state', () {
      final result = Result<int>.failure(error);
      expect(result.isFailure, isTrue);
      expect(result.isSuccess, isFalse);
      expect(result.dataOrNull, isNull);
      expect(result.exceptionOrNull, error);
    });

    test('data rethrows the exception on failure', () {
      final result = Result<int>.failure(error);
      expect(() => result.data, throwsA(same(error)));
    });

    test('when dispatches to the right branch', () {
      expect(
        Result<int>.success(
          2,
        ).when(success: (data) => 'ok:$data', failure: (e) => 'err'),
        'ok:2',
      );
      expect(
        Result<int>.failure(
          error,
        ).when(success: (data) => 'ok', failure: (e) => 'err:${e.code}'),
        'err:E',
      );
    });

    test('whenAsync dispatches asynchronously', () async {
      final out = await Result<int>.success(
        1,
      ).whenAsync(success: (data) async => data + 1, failure: (e) async => -1);
      expect(out, 2);
    });

    test('map transforms success and passes failure through', () {
      expect(Result<int>.success(2).map((d) => d * 10).dataOrNull, 20);
      expect(
        Result<int>.failure(error).map((d) => d * 10).exceptionOrNull,
        error,
      );
    });

    test('mapAsync transforms success', () async {
      final result = await Result<int>.success(5).mapAsync((d) async => d + 1);
      expect(result.dataOrNull, 6);
      final failed = await Result<int>.failure(error).mapAsync((d) async => d);
      expect(failed.exceptionOrNull, error);
    });

    test('flatMap chains success and short-circuits failure', () {
      expect(
        Result<int>.success(
          2,
        ).flatMap((d) => Result<String>.success('v$d')).dataOrNull,
        'v2',
      );
      expect(
        Result<int>.failure(
          error,
        ).flatMap((d) => Result<String>.success('v')).exceptionOrNull,
        error,
      );
    });

    test('flatMapAsync chains asynchronously', () async {
      final result = await Result<int>.success(
        2,
      ).flatMapAsync((d) async => Result<String>.success('v$d'));
      expect(result.dataOrNull, 'v2');
    });

    test('getOrElse and getOrElseLazy supply fallbacks', () {
      expect(Result<int>.success(1).getOrElse(9), 1);
      expect(Result<int>.failure(error).getOrElse(9), 9);
      expect(Result<int>.failure(error).getOrElseLazy(() => 7), 7);
    });

    test('equality and toString', () {
      expect(const Success<int>(1), const Success<int>(1));
      expect(const Success<int>(1).hashCode, const Success<int>(1).hashCode);
      expect(const Success<int>(1).toString(), 'Success(data: 1)');
      expect(Failure<int>(error).toString(), contains('Failure'));
    });
  });

  group('FutureResultExtension', () {
    test('wraps a successful future', () async {
      final result = await Future.value(3).toResult();
      expect(result.dataOrNull, 3);
    });

    test('keeps an XBoardException unchanged', () async {
      final result = await Future<int>.error(error).toResult();
      expect(result.exceptionOrNull, same(error));
    });

    test('uses onError to translate unknown errors', () async {
      final result = await Future<int>.error('nope').toResult(
        onError: (e, st) => XBoardException(code: 'CUSTOM', message: '$e'),
      );
      expect(result.exceptionOrNull!.code, 'CUSTOM');
    });

    test('wraps an unknown error as UNKNOWN_ERROR', () async {
      final result = await Future<int>.error(
        const FormatException('x'),
      ).toResult();
      expect(result.exceptionOrNull!.code, 'UNKNOWN_ERROR');
    });
  });

  group('FunctionResultExtension', () {
    test('wraps a successful call', () {
      final result = (() => 42).toResult();
      expect(result.dataOrNull, 42);
    });

    test('keeps an XBoardException unchanged', () {
      final result = (() => throw error).toResult();
      expect(result.exceptionOrNull, same(error));
    });

    test('wraps an unknown throw', () {
      final result = (() => throw StateError('bad')).toResult();
      expect(result.exceptionOrNull!.code, 'UNKNOWN_ERROR');
    });

    test('onError can override the exception', () {
      final result = (() => throw 'x').toResult(
        onError: (e, st) => XBoardException(code: 'K', message: '$e'),
      );
      expect(result.exceptionOrNull!.code, 'K');
    });
  });
}
