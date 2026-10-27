import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/xboard/features/profile/profile.dart';
import 'package:fl_clash/xboard/features/subscription/services/encrypted_subscription_service.dart';
import 'package:fl_clash/xboard/features/subscription/services/subscription_downloader.dart';
import 'package:fl_clash/xboard/features/subscription/utils/utils.dart';
import 'package:fl_clash/xboard/core/core.dart';
import 'package:fl_clash/xboard/config/utils/config_file_loader.dart';
import 'package:fl_clash/xboard/utils/xboard_core_validation.dart';
import 'package:fl_clash/xboard/services/storage/xboard_storage_provider.dart';
import 'package:fl_clash/common/common.dart';

// 初始化文件级日志器
final _logger = FileLogger('profile_import_service.dart');

final xboardProfileImportServiceProvider = Provider<XBoardProfileImportService>(
  (ref) {
    return XBoardProfileImportService(ref);
  },
);

class XBoardProfileImportService {
  final Ref _ref;
  bool _isImporting = false;
  int _generation = 0;
  SubscriptionCancellation? _cancellation;
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const Duration downloadTimeout = Duration(seconds: 30);
  XBoardProfileImportService(this._ref);

  void cancel() {
    _generation++;
    _cancellation?.cancel();
    _cancellation = null;
    _isImporting = false;
  }

  Future<ImportResult> importSubscription(
    String url, {
    String? ownerEmail,
    Function(ImportStatus, double, String?)? onProgress,
  }) async {
    if (_isImporting) {
      return ImportResult.failure(
        errorMessage: '正在导入中，请稍候',
        errorType: ImportErrorType.unknownError,
      );
    }
    _isImporting = true;
    final generation = ++_generation;
    final cancellation = _cancellation = SubscriptionCancellation();
    final stopwatch = Stopwatch()..start();
    try {
      _logger.info('开始导入订阅配置: $url');

      // 1. 先下载并验证新配置（不删除旧配置）
      onProgress?.call(ImportStatus.downloading, 0.3, '下载配置文件');
      final profile = await _downloadAndValidateProfile(
        url,
        cancellation: cancellation,
      );
      if (generation != _generation) {
        await (await profile.file).safeDelete();
        throw StateError('Subscription import cancelled');
      }
      onProgress?.call(ImportStatus.validating, 0.6, '验证配置格式');

      // 2. 下载成功后，再清理旧配置（避免 UI 闪烁显示"无订阅"）
      onProgress?.call(ImportStatus.cleaning, 0.8, '替换旧的订阅配置');
      // 3. 添加新配置
      onProgress?.call(ImportStatus.adding, 0.9, '添加到配置列表');
      if (ownerEmail != null && ownerEmail.isNotEmpty) {
        final storage = _ref.read(storageServiceProvider);
        final owned = await storage.getOwnedProfileIds(ownerEmail);
        await storage.setOwnedProfileIds(ownerEmail, [...owned, profile.id]);
      }
      if (generation != _generation) {
        await (await profile.file).safeDelete();
        throw StateError('Subscription import cancelled');
      }
      await _addProfile(profile);
      if (generation != _generation) {
        await _ref
            .read(profilesActionProvider.notifier)
            .deleteProfile(profile.id);
        throw StateError('Subscription import cancelled');
      }
      if (ownerEmail != null && ownerEmail.isNotEmpty) {
        final storage = _ref.read(storageServiceProvider);
        final owned = await storage.getOwnedProfileIds(ownerEmail);
        for (final oldId in owned.where((id) => id != profile.id)) {
          if (_ref.read(profilesProvider).any((p) => p.id == oldId)) {
            await _ref
                .read(profilesActionProvider.notifier)
                .deleteProfile(oldId);
          }
        }
        await storage.setOwnedProfileIds(ownerEmail, [profile.id]);
      }

      stopwatch.stop();
      onProgress?.call(ImportStatus.success, 1.0, '导入成功');
      _logger.info('订阅配置导入成功，耗时: ${stopwatch.elapsedMilliseconds}ms');
      return ImportResult.success(
        profile: profile,
        duration: stopwatch.elapsed,
      );
    } catch (e) {
      stopwatch.stop();
      _logger.error('订阅配置导入失败', e);
      final errorType = _classifyError(e);
      final userMessage = _getUserFriendlyErrorMessage(e, errorType);
      onProgress?.call(ImportStatus.failed, 0.0, userMessage);
      return ImportResult.failure(
        errorMessage: userMessage,
        errorType: errorType,
        duration: stopwatch.elapsed,
      );
    } finally {
      if (generation == _generation) {
        _cancellation?.cancel();
        _isImporting = false;
        _cancellation = null;
      }
    }
  }

  Future<ImportResult> importSubscriptionWithRetry(
    String url, {
    Function(ImportStatus, double, String?)? onProgress,
    int retries = maxRetries,
  }) async {
    for (int attempt = 1; attempt <= retries; attempt++) {
      _logger.debug('导入尝试 $attempt/$retries');
      final result = await importSubscription(url, onProgress: onProgress);
      if (result.isSuccess) {
        return result;
      }
      if (result.errorType != ImportErrorType.networkError &&
          result.errorType != ImportErrorType.downloadError) {
        return result;
      }
      if (attempt == retries) {
        return result;
      }
      _logger.debug('等待 ${retryDelay.inSeconds} 秒后重试');
      onProgress?.call(
        ImportStatus.downloading,
        0.0,
        '第 $attempt 次尝试失败，等待重试...',
      );
      await Future.delayed(retryDelay);
    }
    return ImportResult.failure(
      errorMessage: '多次重试后仍然失败',
      errorType: ImportErrorType.networkError,
    );
  }

  Future<Profile> _downloadAndValidateProfile(
    String url, {
    required SubscriptionCancellation cancellation,
  }) async {
    try {
      _logger.info('开始下载配置: $url');

      // 先检查用户配置是否禁用了加密订阅
      final preferEncrypt = await ConfigFileLoaderHelper.getPreferEncrypt();

      // 用户启用加密，检查URL是否需要使用加密订阅服务
      if (preferEncrypt &&
          SubscriptionUrlHelper.shouldUseEncryptedService(url)) {
        _logger.info('🔐 检测到加密订阅URL且用户启用加密，使用加密解密服务');
        return await _downloadEncryptedProfile(url, cancellation);
      }

      // 使用 XBoard 订阅下载服务
      _logger.info('📄 使用 XBoard 订阅下载服务（并发竞速）');
      final profile =
          await SubscriptionDownloader.downloadSubscription(
            url,
            enableRacing: true,
            cancellation: cancellation,
          ).timeout(
            downloadTimeout,
            onTimeout: () {
              throw TimeoutException('下载超时', downloadTimeout);
            },
          );

      _logger.info('配置下载和验证成功: ${profile.label}');
      return profile;
    } on TimeoutException catch (e) {
      throw Exception('下载超时: ${e.message}');
    } on SocketException catch (e) {
      throw Exception('网络连接失败: ${e.message}');
    } on HttpException catch (e) {
      throw Exception('HTTP请求失败: ${e.message}');
    } catch (e) {
      if (e.toString().contains('validateConfig')) {
        throw Exception('配置文件格式错误: $e');
      }
      throw Exception('下载配置失败: $e');
    }
  }

  /// 下载加密的订阅配置
  Future<Profile> _downloadEncryptedProfile(
    String url,
    SubscriptionCancellation cancellation,
  ) async {
    try {
      final preferEncrypt = await ConfigFileLoaderHelper.getPreferEncrypt();
      final token = SubscriptionUrlHelper.extractTokenFromUrl(url);
      final result = await EncryptedSubscriptionService.getSubscriptionSmart(
        token,
        preferEncrypt: preferEncrypt,
        enableRace: preferEncrypt,
        cancellation: cancellation,
      );

      if (!result.success) {
        throw Exception('加密订阅获取失败: ${result.error}');
      }

      _logger.info('加密订阅获取成功');

      // 验证解密后的配置内容
      _logger.debug('📄 验证解密后的配置内容，长度: ${result.content!.length}');
      if (result.content!.trim().isEmpty) {
        throw Exception('解密后的配置内容为空');
      }

      // 记录配置内容的基本统计信息
      final lines = result.content!.split('\n');
      final nonEmptyLines = lines
          .where((line) => line.trim().isNotEmpty)
          .length;
      _logger.debug('📄 配置内容统计: 总行数 ${lines.length}, 非空行数 $nonEmptyLines');

      // 移除冗余的格式检查，让ClashMeta核心进行权威验证
      _logger.debug('⚡ 跳过客户端格式验证，将由ClashMeta核心进行权威验证');

      // 创建Profile并保存解密的配置内容
      _logger.debug('💾 开始保存解密的配置内容到Profile...');
      final profile = Profile.normal(url: url);

      // 使用 saveFile 写入并校验配置内容（iOS 上隧道没开时先存、连接时再由
      // core 权威校验，见 xboard_core_validation.dart）
      final bytes = utf8.encode(result.content!);
      final profileWithContent = await profile.saveFile(
        bytes,
        validate: xboardValidateProfile,
      );
      _logger.info('✅ 配置内容已成功保存并通过ClashMeta核心验证');

      // 获取订阅信息并更新Profile
      _logger.info('📊 开始获取加密订阅的订阅信息...');
      final subscriptionInfo = await ProfileSubscriptionInfoService.instance
          .getSubscriptionInfo(
            subscriptionUserInfo: result.subscriptionUserInfo,
          );
      _logger.info(
        '📊 Profile订阅信息获取完成: upload=${subscriptionInfo.upload}, download=${subscriptionInfo.download}, total=${subscriptionInfo.total}',
      );

      // 返回带有订阅信息的Profile
      final updatedProfile = profileWithContent.copyWith(
        subscriptionInfo: subscriptionInfo,
      );

      _logger.info(
        '🎉 加密配置验证和保存成功！最终Profile订阅信息: ${updatedProfile.subscriptionInfo}',
      );
      _logger.debug('✅ 完整的加密订阅处理流程已成功完成');
      return updatedProfile;
    } catch (e) {
      _logger.error('💥 加密配置下载失败', e);
      _logger.debug('❌ 加密订阅处理流程异常终止');
      throw Exception('加密订阅处理失败: $e');
    }
  }

  Future<void> _addProfile(Profile profile) async {
    try {
      // 1. 添加配置到列表
      _ref.read(profilesProvider.notifier).put(profile);

      // 2. 强制设置为当前配置（订阅导入是用户主动操作，应该立即生效）
      final currentProfileIdNotifier = _ref.read(
        currentProfileIdProvider.notifier,
      );
      currentProfileIdNotifier.value = profile.id;
      _logger.info('✅ 已设置为当前配置: ${profile.label}');

      // [DIAGNOSTIC] 检查 Core 是否在运行
      final isCoreRunning = _ref.read(isStartProvider);
      final coreStatus = _ref.read(coreStatusProvider);
      final groupsBefore = _ref.read(groupsProvider);
      _logger.info(
        '🔍 [DIAGNOSTIC] Core状态: isRunning=$isCoreRunning, '
        'coreStatus=$coreStatus, groupsCount=${groupsBefore.length}',
      );

      // 3. 使用 silence 模式直接应用配置（新路由系统中 homeScaffoldKey 不可用）
      // needSetupProvider 的监听器会触发 handleChangeProfile，但因为 commonScaffoldState
      // 未 mounted 会失败，所以我们在这里手动用 silence 模式触发
      _logger.info('📋 使用 silence 模式应用配置...');
      try {
        await _ref
            .read(setupActionProvider.notifier)
            .applyProfile(silence: true);
        _logger.info('✅ 配置应用成功');
        // [DIAGNOSTIC] applyProfile 成功后再检查 groups
        final groupsAfter = _ref.read(groupsProvider);
        _logger.info(
          '🔍 [DIAGNOSTIC] applyProfile后: groupsCount=${groupsAfter.length}, '
          'groups=${groupsAfter.map((g) => g.name).toList()}',
        );
      } catch (e, stackTrace) {
        _logger.error('❌ 配置应用失败', e, stackTrace);
        // 不抛出异常，因为配置已经保存了
        // [DIAGNOSTIC] 记录失败时的状态
        _logger.error(
          '🔍 [DIAGNOSTIC] applyProfile失败时状态: '
          'isCoreRunning=${_ref.read(isStartProvider)}, '
          'coreStatus=${_ref.read(coreStatusProvider)}',
        );
      }

      _logger.info('配置添加成功: ${profile.label}');
    } catch (e) {
      throw Exception('添加配置失败: $e');
    }
  }

  ImportErrorType _classifyError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('timeout') ||
        errorString.contains('连接失败') ||
        errorString.contains('network')) {
      return ImportErrorType.networkError;
    }
    if (errorString.contains('下载') ||
        errorString.contains('http') ||
        errorString.contains('响应')) {
      return ImportErrorType.downloadError;
    }
    if (errorString.contains('validateconfig') ||
        errorString.contains('格式错误') ||
        errorString.contains('解析') ||
        errorString.contains('配置文件格式错误') ||
        errorString.contains('clash配置') ||
        errorString.contains('invalid config')) {
      return ImportErrorType.validationError;
    }
    if (errorString.contains('存储') ||
        errorString.contains('文件') ||
        errorString.contains('保存')) {
      return ImportErrorType.storageError;
    }
    return ImportErrorType.unknownError;
  }

  String _getUserFriendlyErrorMessage(
    dynamic error,
    ImportErrorType errorType,
  ) {
    final errorString = error.toString();

    switch (errorType) {
      case ImportErrorType.networkError:
        return '网络连接失败，请检查网络设置后重试';
      case ImportErrorType.downloadError:
        // 特殊处理User-Agent相关错误
        if (errorString.contains('Invalid HTTP header field value')) {
          return '配置文件下载失败：HTTP请求头格式错误，请稍后重试';
        }
        if (errorString.contains('FormatException')) {
          return '配置文件下载失败：请求格式错误，请稍后重试';
        }
        return '配置文件下载失败，请检查订阅链接是否正确';
      case ImportErrorType.validationError:
        return '配置文件格式验证失败，请联系服务提供商检查配置格式';
      case ImportErrorType.storageError:
        return '保存配置失败，请检查存储空间';
      case ImportErrorType.unknownError:
        // 简化未知错误的显示，避免显示技术细节
        if (errorString.contains('Invalid HTTP header field value') ||
            errorString.contains('FormatException')) {
          return '导入失败：应用配置错误，请稍后重试或重启应用';
        }
        return '导入失败，请稍后重试或联系技术支持';
    }
  }

  bool get isImporting => _isImporting;
}
