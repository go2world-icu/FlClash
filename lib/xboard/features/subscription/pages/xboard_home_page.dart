import 'dart:async';
import 'dart:io';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/xboard/config/xboard_config.dart';
import 'package:fl_clash/xboard/core/core.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'dart:convert';
import 'package:fl_clash/xboard/features/remote_task/services/device_info_service.dart';
import 'package:fl_clash/xboard/features/auth/pages/login_page.dart';
import 'package:flutter_xboard_sdk/flutter_xboard_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/l10n/l10n.dart';

import 'package:fl_clash/xboard/features/shared/shared.dart';
import 'package:fl_clash/xboard/features/latency/services/auto_latency_service.dart';
import 'package:fl_clash/xboard/features/subscription/services/subscription_status_checker.dart';
import 'package:fl_clash/xboard/features/profile/providers/profile_import_provider.dart';
import '../widgets/subscription_usage_card.dart';
import '../widgets/xboard_connect_button.dart';
class XBoardHomePage extends ConsumerStatefulWidget {
  const XBoardHomePage({super.key});
  @override
  ConsumerState<XBoardHomePage> createState() => _XBoardHomePageState();
}
class _XBoardHomePageState extends ConsumerState<XBoardHomePage>
    with AutomaticKeepAliveClientMixin {
  bool _hasInitialized = false;
  bool _hasStartedLatencyTesting = false;
  bool _hasCheckedSubscriptionStatus = false;
  bool _isUploading = false;
  bool _hasUploaded = false;
  
  @override
  bool get wantKeepAlive => true;  // 保持页面状态，防止重建
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_hasInitialized) return;
      _hasInitialized = true;
      final userState = ref.read(xboardUserProvider);
      if (userState.isAuthenticated) {
        // 等待订阅导入完成后再检查订阅状态
        _waitForSubscriptionImportThenCheck();
      }
      autoLatencyService.initialize(ref);
      _waitForGroupsAndStartTesting();
    });
    ref.listenManual(xboardUserProvider, (previous, next) {
      if (next.errorMessage == 'TOKEN_EXPIRED') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showTokenExpiredDialog();
        });
      }
    });
    
    // 监听订阅导入完成事件
    ref.listenManual(profileImportProvider, (previous, next) {
      // 从导入中变为完成（成功或失败）
      if (previous?.isImporting == true && !next.isImporting && !_hasCheckedSubscriptionStatus) {
        _hasCheckedSubscriptionStatus = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && context.mounted) {
            subscriptionStatusChecker.checkSubscriptionStatusOnStartup(context, ref);
          }
        });
      }
    });

    ref.listenManual(currentProfileProvider, (previous, next) {
      if (previous?.label != next?.label && previous != null) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            autoLatencyService.testCurrentNode(forceTest: true);
          }
        });
      }
    });
    ref.listenManual(groupsProvider, (previous, next) {
      if ((previous?.isEmpty ?? true) && next.isNotEmpty && !_hasStartedLatencyTesting) {
        _hasStartedLatencyTesting = true;
        Future.delayed(const Duration(seconds: 2), () {
          // 使用 ref.maybeRead 安全读取，避免在 dispose 后使用
          try {
            _performInitialLatencyTest();
          } catch (e) {
            // 忽略 ref 错误
          }
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);  // 必须调用，配合 AutomaticKeepAliveClientMixin
    
    // 根据操作系统平台判断设备类型
    final isDesktop = Platform.isLinux || Platform.isWindows || Platform.isMacOS;
    
    return Scaffold(
      appBar: isDesktop ? null : AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Consumer(
        builder: (_, ref, __) {
          // 获取屏幕高度并计算自适应间距
          final screenHeight = MediaQuery.of(context).size.height;
        final appBarHeight = kToolbarHeight;
        final statusBarHeight = MediaQuery.of(context).padding.top;
        final bottomNavHeight = 60.0; // 底部导航栏高度
        final availableHeight = screenHeight - appBarHeight - statusBarHeight - bottomNavHeight;
        
        // 根据可用高度调整间距
        double sectionSpacing;
        double verticalPadding;
        double horizontalPadding;
        
        if (availableHeight < 500) {
          // 小屏幕：紧凑布局
          sectionSpacing = 8.0;
          verticalPadding = 8.0;
          horizontalPadding = 12.0;
        } else if (availableHeight < 650) {
          // 中等屏幕：适中布局
          sectionSpacing = 10.0;
          verticalPadding = 10.0;
          horizontalPadding = 16.0;
        } else {
          // 大屏幕：标准布局
          sectionSpacing = 14.0;
          verticalPadding = 12.0;
          horizontalPadding = 16.0;
        }
        
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                Theme.of(context).colorScheme.surface,
              ],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: verticalPadding),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - (2 * verticalPadding),
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const NoticeBanner(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                            child: _buildUsageSection(),
                          ),
                          // SizedBox(height: sectionSpacing),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          //   child: _buildProxyModeSection(),
                          // ),
                          // SizedBox(height: sectionSpacing),
                          // const NodeSelectorBar(),
                          // SizedBox(height: sectionSpacing),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          //   child: _buildConnectionSection(),
                          // ),
                          // 底部弹性空间
                          if (availableHeight > 600) const Spacer(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
        },
      ),
      bottomNavigationBar: _buildLogUploadFooter(),
    );
  }

  /// 禁用态颜色（上传中或已上报）
  Color get _disabledColor => Theme.of(context)
      .colorScheme.onSurfaceVariant
      .withValues(alpha: _hasUploaded ? 0.4 : 0.5);

  /// 构建日志上报底栏（固定在页面右下角）
  Widget _buildLogUploadFooter() {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '遇到问题？',
            style: TextStyle(
              color: _hasUploaded
                  ? Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4)
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: (_isUploading || _hasUploaded) ? null : _uploadLogs,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_hasUploaded)
                  Icon(
                    Icons.bug_report,
                    size: 14,
                    color: _disabledColor,
                  ),
                if (!_hasUploaded) const SizedBox(width: 4),
                Text(
                  _isUploading ? '上传中...' : (_hasUploaded ? '已上报' : '日志上报'),
                  style: TextStyle(
                    color: _disabledColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    decoration: (_isUploading || _hasUploaded)
                        ? null
                        : TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 上传日志到服务端
  Future<void> _uploadLogs() async {
    final fileOutput = XBoardLogger.fileOutput;
    if (fileOutput == null) {
      _showSnackBar('日志未启用');
      return;
    }

    setState(() => _isUploading = true);

    try {
      // 读取最新的日志文件
      final logFiles = await fileOutput.getLogFiles();
      if (logFiles.isEmpty) {
        _showSnackBar('暂无日志文件');
        return;
      }
      logFiles.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      final latestFile = logFiles.first;
      final fileBytes = await latestFile.readAsBytes();
      final filename = latestFile.path.split(Platform.pathSeparator).last;

      // 设备信息
      final deviceInfoResult = await DeviceInfoService.collectBasicDeviceInfo();
      final deviceInfoJson = deviceInfoResult['status'] == 'success'
          ? jsonEncode(deviceInfoResult['device_info'])
          : '{}';

      final reportUrl = XBoardConfig.reportLogUrl;
      if (reportUrl == null || reportUrl.isEmpty) {
        _showSnackBar('未配置日志上报服务器地址');
        return;
      }

      final success = await XBoardSDK.instance.reportLog(
        fileBytes,
        filename,
        deviceInfoJson: deviceInfoJson,
        customUrl: reportUrl,
      );

      if (!mounted) return;

      if (success) {
        _hasUploaded = true;
        _showSnackBar('日志上报成功 ✓');
      } else {
        _showSnackBar('日志上报失败');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('上报异常: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  /// 显示 SnackBar 提示
  void _showSnackBar(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  Widget _buildUsageSection() {
    return Consumer(
      builder: (context, ref, child) {
        final userInfo = ref.userInfo;
        final subscriptionInfo = ref.subscriptionInfo;
        final currentProfile = ref.watch(currentProfileProvider);
        return SubscriptionUsageCard(
          subscriptionInfo: subscriptionInfo,
          userInfo: userInfo,
          profileSubscriptionInfo: currentProfile?.subscriptionInfo,
        );
      },
    );
  }
  Widget _buildConnectionSection() {
    return Consumer(
      builder: (context, ref, child) {
        return const XBoardConnectButton(isFloating: false);
      },
    );
  }
  Widget _buildProxyModeSection() {
    return const XBoardOutboundMode();
  }
  /// 等待订阅导入完成后再检查订阅状态（备用方案）
  /// 如果3秒后还没有触发导入完成监听器，则主动检查
  void _waitForSubscriptionImportThenCheck() async {
    await Future.delayed(const Duration(seconds: 3));

    // 如果已经通过监听器检查过了，就不再检查
    if (_hasCheckedSubscriptionStatus || !mounted) {
      return;
    }

    _hasCheckedSubscriptionStatus = true;
    if (mounted && context.mounted) {
      try {
        subscriptionStatusChecker.checkSubscriptionStatusOnStartup(context, ref);
      } catch (e) {
        // ignore ref errors after dispose
      }
    }
  }
  
  void _showTokenExpiredDialog() {
    if (!mounted) return;
    final appLocalizations = AppLocalizations.of(context);
    final userNotifier = ref.read(xboardUserProvider.notifier);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(appLocalizations.xboardTokenExpiredTitle),
        content: Text(appLocalizations.xboardTokenExpiredContent),
        actions: [
          TextButton(
            onPressed: () async {
              // 先关闭对话框
              if (context.mounted) {
                Navigator.of(context).pop();
              }
              // 清除错误状态
              userNotifier.clearTokenExpiredError();
              // 处理 Token 过期（清除数据）
              await userNotifier.handleTokenExpired();
              // 导航到登录页
              if (context.mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
            child: Text(appLocalizations.xboardRelogin),
          ),
        ],
      ),
    );
  }

  void _waitForGroupsAndStartTesting() {
    if (_hasStartedLatencyTesting) {
      return;
    }
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      try {
        final groups = ref.read(groupsProvider);
        if (groups.isNotEmpty && !_hasStartedLatencyTesting) {
          timer.cancel();
          _hasStartedLatencyTesting = true;
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              _performInitialLatencyTest();
            }
          });
        }
      } catch (e) {
        // 忽略可能的 StateError
        timer.cancel();
      }
    });
  }
  void _performInitialLatencyTest() {
    if (!mounted) return;
    autoLatencyService.testCurrentNode();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      try {
        final userState = ref.read(xboardUserProvider);
        if (userState.isAuthenticated) {
          autoLatencyService.testCurrentGroupNodes();
        }
      } catch (e) {
        // ignore ref errors after dispose
      }
    });
  }
} 