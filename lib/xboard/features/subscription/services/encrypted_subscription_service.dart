import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fl_clash/xboard/config/xboard_config.dart';
import 'package:fl_clash/xboard/config/utils/config_file_loader.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
// 已从core/utils导出
import 'package:fl_clash/xboard/core/core.dart';
import 'package:fl_clash/xboard/infrastructure/infrastructure.dart';
import 'package:fl_clash/xboard/infrastructure/http/user_agent_config.dart';
import 'package:fl_clash/xboard/infrastructure/http/board_transport.dart';
import 'package:fl_clash/xboard/features/subscription/services/subscription_downloader.dart';
import 'package:fl_clash/xboard/utils/xboard_core_validation.dart';
import 'concurrent_subscription_service.dart';

// 初始化文件级日志器
final _logger = FileLogger('encrypted_subscription_service.dart');

/// 加密订阅获取服务
///
/// 负责从XBoard加密端点获取订阅数据并解密
class EncryptedSubscriptionService {
  static const Duration requestTimeout = Duration(seconds: 30);

  /// 从登录数据中获取加密订阅（推荐方法）
  ///
  /// [preferEncrypt] 是否优先使用加密端点，默认true
  /// [enableRace] 是否启用订阅URL竞速，默认true
  ///
  /// 返回解密后的Clash配置内容
  static Future<SubscriptionResult> getEncryptedSubscriptionFromLogin({
    bool preferEncrypt = true,
    bool enableRace = true,
    SubscriptionCancellation? cancellation,
  }) async {
    try {
      _logger.info('从登录数据获取加密订阅');

      // 1. 获取订阅信息（注意：这里获取的是订阅数据，不是Auth Token）
      final subscriptionData = await XBoardSDK.instance.subscription
          .getSubscription();

      final subscribeUrl = subscriptionData.subscribeUrl;
      if (subscribeUrl == null || subscribeUrl.isEmpty) {
        return SubscriptionResult.failure('订阅URL为空');
      }

      // 2. 从订阅URL中提取订阅token（不是Auth Token！）
      final token = _extractTokenFromSubscriptionUrl(subscribeUrl);

      if (token == null || token.isEmpty) {
        return SubscriptionResult.failure('无法从订阅URL中提取token');
      }

      return await getSubscriptionSmart(
        token,
        preferEncrypt: preferEncrypt,
        enableRace: enableRace,
        cancellation: cancellation,
      );
    } catch (e) {
      _logger.error('从登录数据获取订阅失败', e);
      return SubscriptionResult.failure('从登录数据获取订阅失败: $e');
    }
  }

  /// 从订阅URL中提取token
  ///
  /// 支持多种格式：
  /// - https://domain.com/s/abc123...
  /// - https://domain.com/api/v1/client/subscribe?token=abc123...
  static String? _extractTokenFromSubscriptionUrl(String url) {
    try {
      final uri = Uri.parse(url);

      // 方式1: 查询参数中的token
      if (uri.queryParameters.containsKey('token')) {
        return uri.queryParameters['token'];
      }

      // 方式2: 路径中的最后一段作为token (如 /s/xxx)
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        final lastSegment = pathSegments.last;
        // 验证是否像token（一般是16位或更长的字符串）
        if (lastSegment.length >= 16) {
          return lastSegment;
        }
      }

      return null;
    } catch (e) {
      _logger.error('提取订阅token失败', e);
      return null;
    }
  }

  /// 获取并解密加密的订阅数据（使用已知token）
  ///
  /// [token] 用户的订阅token
  /// [preferEncrypt] 是否优先使用加密端点，默认true
  /// [enableRace] 是否启用订阅URL竞速，默认true
  ///
  /// 返回解密后的Clash配置内容
  static Future<SubscriptionResult> getEncryptedSubscription(
    String token, {
    bool preferEncrypt = true,
    bool enableRace = true,
    SubscriptionCancellation? cancellation,
  }) async {
    return _raceSubscription(
      token,
      encrypt: true,
      enableRace: enableRace,
      cancellation: cancellation,
    );
  }

  /// 获取加密数据（支持重试）
  ///
  /// [url] 订阅URL
  /// 返回加密的数据内容和订阅信息
  static Future<DataResult> _fetchEncryptedData(
    String url, {
    String? proxyUrl,
    SubscriptionCancellation? cancellation,
  }) async {
    final uri = Uri.parse(url);
    final client = await XBoardTransport.create(uri, proxyUrl: proxyUrl);
    cancellation?.attach(client);
    client.connectionTimeout = requestTimeout;
    try {
      final request = await client.getUrl(uri).timeout(requestTimeout);
      request.followRedirects = false;
      request.headers.set(
        HttpHeaders.userAgentHeader,
        await UserAgentConfig.get(UserAgentScenario.subscription),
      );
      final response = await request.close().timeout(requestTimeout);
      if (response.statusCode != HttpStatus.ok) {
        return DataResult.failure('HTTP ${response.statusCode}');
      }
      final bytes = BytesBuilder(copy: false);
      await response
          .forEach((chunk) {
            if (cancellation?.isCancelled == true ||
                bytes.length + chunk.length > 8 * 1024 * 1024) {
              throw const HttpException(
                'Subscription download cancelled or too large',
              );
            }
            bytes.add(chunk);
          })
          .timeout(requestTimeout);
      final body = utf8.decode(bytes.takeBytes());
      final info = response.headers.value('subscription-userinfo');
      try {
        final data = jsonDecode(body);
        if (data is Map<String, dynamic> && data['data'] is String) {
          return DataResult.success(
            data['data'] as String,
            subscriptionUserInfo: info,
          );
        }
      } on FormatException {
        // The endpoint may return the encrypted payload directly.
      }
      return DataResult.success(body, subscriptionUserInfo: info);
    } catch (error) {
      return DataResult.failure(error.toString());
    } finally {
      cancellation?.detach(client);
      client.close(force: true);
    }
  }

  static Future<SubscriptionResult> _raceSubscription(
    String token, {
    required bool encrypt,
    required bool enableRace,
    SubscriptionCancellation? cancellation,
  }) async {
    final settings = XBoardConfig.subscriptionInfo;
    if (settings == null || settings.urls.isEmpty) {
      return SubscriptionResult.failure('未找到订阅配置信息');
    }
    final urls = [
      for (final source in settings.urls)
        if (!encrypt || source.supportEncrypt)
          source.buildSubscriptionUrl(token, preferEncrypt: encrypt),
    ];
    if (urls.isEmpty) return SubscriptionResult.failure('没有可用的订阅端点');
    final routes = <(String, String?)>[
      for (final url in enableRace ? urls : urls.take(1))
        for (final proxy
            in enableRace
                ? <String?>[null, ...XBoardConfig.allProxyUrls]
                : <String?>[null])
          (url, proxy),
    ];
    final active = SubscriptionCancellation();
    if (cancellation != null) {
      if (cancellation.isCancelled) active.cancel();
      unawaited(cancellation.whenCancelled.then((_) => active.cancel()));
    }
    final selected = Completer<SubscriptionResult>();
    final decryptKey = encrypt
        ? await ConfigFileLoaderHelper.getDecryptKey()
        : null;
    var next = 0;
    var finished = 0;
    String? firstError;

    Future<void> worker() async {
      while (!selected.isCompleted &&
          !active.isCancelled &&
          next < routes.length) {
        final (url, proxy) = routes[next++];
        try {
          final downloaded = await _fetchEncryptedData(
            url,
            proxyUrl: proxy,
            cancellation: active,
          );
          if (!downloaded.success) {
            throw StateError(downloaded.error ?? '订阅下载失败');
          }
          final String content;
          final String? keyUsed;
          if (encrypt) {
            final decrypted = XBoardDecryptHelper.smartDecrypt(
              downloaded.data!,
              configuredKey: decryptKey!,
              tryFallback: true,
            );
            if (!decrypted.success) throw const FormatException('解密失败');
            content = decrypted.content;
            keyUsed = decrypted.keyUsed;
          } else {
            content = downloaded.data!;
            keyUsed = null;
          }
          final localError = xboardValidateConfigContent(content);
          if (localError.isNotEmpty) throw FormatException(localError);
          final coreError = await xboardValidateConfigData(content);
          if (coreError.isNotEmpty) throw FormatException(coreError);
          if (!selected.isCompleted && !active.isCancelled) {
            selected.complete(
              SubscriptionResult.success(
                content: content,
                encryptionUsed: encrypt,
                keyUsed: keyUsed,
                originalUrl: url,
                subscriptionUserInfo: downloaded.subscriptionUserInfo,
              ),
            );
            active.cancel();
          }
        } catch (error) {
          firstError ??= error.toString();
        } finally {
          finished++;
          if (finished == routes.length && !selected.isCompleted) {
            selected.complete(
              SubscriptionResult.failure(firstError ?? '订阅源不可用'),
            );
          }
        }
      }
    }

    final workers = [for (var i = 0; i < 3 && i < routes.length; i++) worker()];
    try {
      return await Future.any<SubscriptionResult>([
        selected.future,
        active.whenCancelled.then(
          (_) => SubscriptionResult.failure('Subscription import cancelled'),
        ),
      ]).timeout(
        const Duration(seconds: 35),
        onTimeout: () => SubscriptionResult.failure('订阅竞速超时'),
      );
    } finally {
      active.cancel();
      unawaited(Future.wait(workers));
    }
  }

  /// 回退到普通订阅获取
  ///
  /// [token] 用户token
  /// [enableRace] 是否启用订阅URL竞速
  /// 当加密订阅失败时的备用方案
  static Future<SubscriptionResult> fallbackToNormalSubscription(
    String token, {
    bool enableRace = true,
    SubscriptionCancellation? cancellation,
  }) async {
    return _raceSubscription(
      token,
      encrypt: false,
      enableRace: enableRace,
      cancellation: cancellation,
    );
  }

  /// 获取订阅（智能选择加密或普通）
  ///
  /// [token] 可选的用户token，如果不提供则从登录数据获取
  /// [preferEncrypt] 是否优先使用加密，默认true
  /// [enableRace] 是否启用订阅URL竞速，默认true
  ///
  /// 先尝试加密订阅，失败后自动回退到普通订阅
  static Future<SubscriptionResult> getSubscriptionSmart(
    String? token, {
    bool preferEncrypt = true,
    bool enableRace = true,
    SubscriptionCancellation? cancellation,
  }) async {
    try {
      // 如果没有提供token，优先从登录数据获取
      if (token == null || token.isEmpty) {
        _logger.info('未提供token，从登录数据获取');
        return await getEncryptedSubscriptionFromLogin(
          preferEncrypt: preferEncrypt,
          enableRace: enableRace,
          cancellation: cancellation,
        );
      }

      // 使用提供的token
      if (preferEncrypt) {
        // 先尝试加密订阅
        final encryptedResult = await getEncryptedSubscription(
          token,
          preferEncrypt: true,
          enableRace: enableRace,
          cancellation: cancellation,
        );
        if (encryptedResult.success) {
          return encryptedResult;
        }

        _logger.warning('加密订阅失败，尝试普通订阅: ${encryptedResult.error}');

        // 回退到普通订阅
        return await fallbackToNormalSubscription(
          token,
          enableRace: enableRace,
          cancellation: cancellation,
        );
      } else {
        // 直接使用普通订阅
        return await fallbackToNormalSubscription(
          token,
          enableRace: enableRace,
          cancellation: cancellation,
        );
      }
    } catch (e) {
      return SubscriptionResult.failure('智能订阅获取失败: $e');
    }
  }

  // ========== 新增：并发竞速订阅获取方法 ==========

  /// 并发竞速获取加密订阅（从登录数据，推荐方法）
  ///
  /// 使用多个订阅源并发请求，第一个成功的获胜，自动取消其他请求
  ///
  /// [preferEncrypt] 是否优先使用加密端点，默认true
  /// [enableRace] 是否启用竞速模式，如果false则回退到标准单一请求，默认true
  ///
  /// 返回最快成功的订阅结果
  static Future<SubscriptionResult> getRaceEncryptedSubscriptionFromLogin({
    bool preferEncrypt = true,
    bool enableRace = true,
  }) async {
    try {
      _logger.info('[竞速增强] 获取加密订阅，竞速模式: $enableRace');

      // 如果未启用竞速模式，回退到原始方法
      if (!enableRace) {
        _logger.info('[竞速增强] 竞速模式已禁用，使用标准获取方式');
        return await getEncryptedSubscriptionFromLogin(
          preferEncrypt: preferEncrypt,
        );
      }

      // 使用并发竞速服务
      return await ConcurrentSubscriptionService.raceGetEncryptedSubscriptionFromLogin(
        preferEncrypt: preferEncrypt,
      );
    } catch (e) {
      _logger.error('[竞速增强] 竞速获取失败，回退到标准方式', e);

      // 竞速失败时回退到标准方式
      return await getEncryptedSubscriptionFromLogin(
        preferEncrypt: preferEncrypt,
      );
    }
  }

  /// 并发竞速获取加密订阅（使用token）
  ///
  /// [token] 用户的订阅token
  /// [preferEncrypt] 是否优先使用加密端点，默认true
  /// [enableRace] 是否启用竞速模式，默认true
  ///
  /// 返回最快成功的订阅结果
  static Future<SubscriptionResult> getRaceEncryptedSubscription(
    String token, {
    bool preferEncrypt = true,
    bool enableRace = true,
  }) async {
    try {
      _logger.info('[竞速增强] 获取加密订阅，竞速模式: $enableRace');

      // 如果未启用竞速模式，回退到原始方法
      if (!enableRace) {
        return await getEncryptedSubscription(
          token,
          preferEncrypt: preferEncrypt,
        );
      }

      // 使用并发竞速服务
      return await ConcurrentSubscriptionService.raceGetEncryptedSubscription(
        token,
        preferEncrypt: preferEncrypt,
      );
    } catch (e) {
      _logger.error('[竞速增强] 竞速获取失败，回退到标准方式', e);

      // 竞速失败时回退到标准方式
      return await getEncryptedSubscription(
        token,
        preferEncrypt: preferEncrypt,
      );
    }
  }
}

/// 数据获取结果
class DataResult {
  final bool success;
  final String? data;
  final String? subscriptionUserInfo;
  final String? error;

  const DataResult._({
    required this.success,
    this.data,
    this.subscriptionUserInfo,
    this.error,
  });

  factory DataResult.success(String data, {String? subscriptionUserInfo}) =>
      DataResult._(
        success: true,
        data: data,
        subscriptionUserInfo: subscriptionUserInfo,
      );
  factory DataResult.failure(String error) =>
      DataResult._(success: false, error: error);
}

/// 订阅获取结果
class SubscriptionResult {
  final bool success;
  final String? content;
  final bool encryptionUsed;
  final String? keyUsed;
  final String? originalUrl;
  final String? subscriptionUserInfo;
  final String? error;

  const SubscriptionResult._({
    required this.success,
    this.content,
    this.encryptionUsed = false,
    this.keyUsed,
    this.originalUrl,
    this.subscriptionUserInfo,
    this.error,
  });

  factory SubscriptionResult.success({
    required String content,
    required bool encryptionUsed,
    String? keyUsed,
    String? originalUrl,
    String? subscriptionUserInfo,
  }) => SubscriptionResult._(
    success: true,
    content: content,
    encryptionUsed: encryptionUsed,
    keyUsed: keyUsed,
    originalUrl: originalUrl,
    subscriptionUserInfo: subscriptionUserInfo,
  );

  factory SubscriptionResult.failure(String error) =>
      SubscriptionResult._(success: false, error: error);

  @override
  String toString() {
    return 'SubscriptionResult(success: $success, encryption: $encryptionUsed, keyUsed: $keyUsed)';
  }
}
