import 'package:fl_clash/xboard/features/subscription/utils/subscription_url_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SubscriptionUrlHelper.initialize', () {
    test('is idempotent', () {
      SubscriptionUrlHelper.initialize();
      SubscriptionUrlHelper.initialize();
      expect(true, isTrue);
    });
  });

  group('extractTokenFromUrl', () {
    test('reads the token query parameter', () {
      expect(
        SubscriptionUrlHelper.extractTokenFromUrl(
          'https://domain.com/api/v1/client/subscribe?token=abc123',
        ),
        'abc123',
      );
    });

    test('reads a hex token from the last path segment', () {
      expect(
        SubscriptionUrlHelper.extractTokenFromUrl(
          'https://domain.com/subscription/0123456789abcdef0123456789abcdef',
        ),
        '0123456789abcdef0123456789abcdef',
      );
    });

    test('returns null for a short or non-hex last segment', () {
      expect(
        SubscriptionUrlHelper.extractTokenFromUrl('https://domain.com/short'),
        isNull,
      );
      expect(
        SubscriptionUrlHelper.extractTokenFromUrl(
          'https://domain.com/not-hex-and-long-enough-zzz',
        ),
        isNull,
      );
    });

    test('returns null when there is no path', () {
      expect(
        SubscriptionUrlHelper.extractTokenFromUrl('https://domain.com'),
        isNull,
      );
    });
  });

  group('isEncryptedSubscriptionUrl', () {
    test('detects encrypt in the path case-insensitively', () {
      expect(
        SubscriptionUrlHelper.isEncryptedSubscriptionUrl(
          'https://domain.com/api/v2/subscription-encrypt/xxx',
        ),
        isTrue,
      );
      expect(
        SubscriptionUrlHelper.isEncryptedSubscriptionUrl(
          'https://domain.com/api/ENCRYPT/xxx',
        ),
        isTrue,
      );
    });

    test('is false for a normal url', () {
      expect(
        SubscriptionUrlHelper.isEncryptedSubscriptionUrl(
          'https://domain.com/subscribe',
        ),
        isFalse,
      );
    });
  });

  group('shouldUseEncryptedService', () {
    test('is true for an encrypt endpoint', () {
      expect(
        SubscriptionUrlHelper.shouldUseEncryptedService(
          'https://domain.com/api/v2/subscription-encrypt/x',
        ),
        isTrue,
      );
    });

    test('is true when a long token is present', () {
      expect(
        SubscriptionUrlHelper.shouldUseEncryptedService(
          'https://domain.com/subscribe?token=0123456789abcdef',
        ),
        isTrue,
      );
    });

    test('is false otherwise', () {
      expect(
        SubscriptionUrlHelper.shouldUseEncryptedService(
          'https://domain.com/plain',
        ),
        isFalse,
      );
      expect(
        SubscriptionUrlHelper.shouldUseEncryptedService(
          'https://domain.com/subscribe?token=short',
        ),
        isFalse,
      );
    });
  });
}
