import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/xboard/config/xboard_config.dart';
import 'package:fl_clash/xboard/core/core.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'dart:convert';
import 'package:fl_clash/xboard/features/remote_task/services/device_info_service.dart';
import 'package:fl_clash/xboard/features/auth/pages/login_page.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/l10n/l10n.dart';

import 'package:fl_clash/xboard/features/shared/shared.dart';
import 'package:fl_clash/xboard/features/latency/services/auto_latency_service.dart';
import 'package:fl_clash/xboard/features/subscription/services/subscription_status_checker.dart';
import 'package:fl_clash/xboard/features/profile/providers/profile_import_provider.dart';
import 'package:fl_clash/widgets/widgets.dart';
import '../widgets/subscription_usage_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/error_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/invite_rules_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/invite_qr_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/invite_stats_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/wallet_details_card.dart';
import 'package:fl_clash/xboard/features/invite/widgets/commission_history_card.dart';
import 'package:fl_clash/xboard/features/invite/providers/invite_provider.dart';
import 'package:fl_clash/xboard/features/invite/dialogs/logout_dialog.dart';
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
  bool get wantKeepAlive => true;  // 淇濇寔椤甸潰鐘舵€侊紝闃叉閲嶅缓
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_hasInitialized) return;
      _hasInitialized = true;
      final userState = ref.read(xboardUserProvider);
      if (userState.isAuthenticated) {
        // 绛夊緟璁㈤槄瀵煎叆瀹屾垚鍚庡啀妫€鏌ヨ闃呯姸鎬?
        _waitForSubscriptionImportThenCheck();
        // 寮傛鍔犺浇閭€璇锋暟鎹?
        _loadInviteData();
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
    
    // 鐩戝惉璁㈤槄瀵煎叆瀹屾垚浜嬩欢
    ref.listenManual(profileImportProvider, (previous, next) {
      // 浠庡鍏ヤ腑鍙樹负瀹屾垚锛堟垚鍔熸垨澶辫触锛?
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
          // 浣跨敤 ref.maybeRead 瀹夊叏璇诲彇锛岄伩鍏嶅湪 dispose 鍚庝娇鐢?
          try {
            _performInitialLatencyTest();
          } catch (e) {
            // 蹇界暐 ref 閿欒
          }
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);  // 蹇呴』璋冪敤锛岄厤鍚?AutomaticKeepAliveClientMixin
    
    // 鏍规嵁鎿嶄綔绯荤粺骞冲彴鍒ゆ柇璁惧绫诲瀷
    final isDesktop = Platform.isLinux || Platform.isWindows || Platform.isMacOS;
    
    return Scaffold(
      appBar: isDesktop ? null : AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Consumer(
        builder: (_, ref, __) {
          // 鑾峰彇灞忓箷楂樺害骞惰绠楄嚜閫傚簲闂磋窛
          final screenHeight = MediaQuery.of(context).size.height;
        final appBarHeight = kToolbarHeight;
        final statusBarHeight = MediaQuery.of(context).padding.top;
        final bottomNavHeight = 60.0; // 搴曢儴瀵艰埅鏍忛珮搴?
        final availableHeight = screenHeight - appBarHeight - statusBarHeight - bottomNavHeight;
        
        // 鏍规嵁鍙敤楂樺害璋冩暣闂磋窛
        double sectionSpacing;
        double verticalPadding;
        double horizontalPadding;
        
        if (availableHeight < 500) {
          // 灏忓睆骞曪細绱у噾甯冨眬
          sectionSpacing = 8.0;
          verticalPadding = 8.0;
          horizontalPadding = 12.0;
        } else if (availableHeight < 650) {
          // 涓瓑灞忓箷锛氶€備腑甯冨眬
          sectionSpacing = 10.0;
          verticalPadding = 10.0;
          horizontalPadding = 16.0;
        } else {
          // 澶у睆骞曪細鏍囧噯甯冨眬
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
                  padding: EdgeInsets.symmetric(
                    vertical: verticalPadding,
                    horizontal: horizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const NoticeBanner(),
                      SizedBox(height: sectionSpacing),
                      _buildUsageGrid(context, availableHeight),
                      SizedBox(height: sectionSpacing),
                      _buildInviteSection(),
                      SizedBox(height: sectionSpacing),
                      _buildLogUploadRow(),
                      SizedBox(height: sectionSpacing),
                      _buildLogoutButton(),
                    ],
                  ),
                );
              },
            ),
          ),
        );
        },
      ),
    );
  }

  /// 绂佺敤鎬侀鑹诧紙涓婁紶涓垨宸蹭笂鎶ワ級
  Color get _disabledColor => Theme.of(context)
      .colorScheme.onSurfaceVariant
      .withValues(alpha: _hasUploaded ? 0.4 : 0.5);

  /// 寮傛鍔犺浇閭€璇锋暟鎹?
  Future<void> _loadInviteData() async {
    try {
      await ref.read(inviteProvider.notifier).refresh();
      if (!mounted) return;
      final inviteState = ref.read(inviteProvider);
      if (!inviteState.hasInviteData || inviteState.inviteData!.codes.isEmpty) {
        await ref.read(inviteProvider.notifier).generateInviteCode();
      }
    } catch (_) {}
  }

  /// 鏋勫缓閭€璇烽〉闈㈠唴瀹?
  Widget _buildInviteSection() {
    return Consumer(
      builder: (_, ref, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ErrorCard(),
            SizedBox(height: 16),
            InviteRulesCard(),
            SizedBox(height: 16),
            InviteQrCard(),
            SizedBox(height: 16),
            InviteStatsCard(),
            SizedBox(height: 16),
            WalletDetailsCard(),
            SizedBox(height: 16),
            CommissionHistoryCard(),
          ],
        );
      },
    );
  }

  /// 鏋勫缓鏃ュ織涓婃姤琛岋紙鍐呭祵鍦ㄦ粴鍔ㄥ唴瀹逛腑锛?
  Widget _buildLogUploadRow() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '閬囧埌闂锛?,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          GestureDetector(
            onTap: (_isUploading || _hasUploaded) ? null : _uploadLogs,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_hasUploaded)
                  Icon(Icons.bug_report, size: 14, color: _disabledColor),
                if (!_hasUploaded) const SizedBox(width: 4),
                Text(
                  _isUploading ? '涓婁紶涓?..' : (_hasUploaded ? '宸蹭笂鎶? : '鏃ュ織涓婃姤'),
                  style: TextStyle(
                    color: _disabledColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    decoration: (_isUploading || _hasUploaded) ? null : TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 鏋勫缓閫€鍑虹櫥褰曟寜閽?
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutDialog(),
        icon: const Icon(Icons.logout, color: Colors.red),
        label: Text(
          AppLocalizations.of(context).logout,
          style: const TextStyle(color: Colors.red),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.red.shade300),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  /// 鏄剧ず閫€鍑虹‘璁ゅ璇濇
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => const LogoutDialog(),
    );
  }
  /// 涓婁紶鏃ュ織鍒版湇鍔＄
  Future<void> _uploadLogs() async {
    final fileOutput = XBoardLogger.fileOutput;
    if (fileOutput == null) {
      _showSnackBar('鏃ュ織鏈惎鐢?);
      return;
    }

    setState(() => _isUploading = true);

    try {
      // 璇诲彇鏈€鏂扮殑鏃ュ織鏂囦欢
      final logFiles = await fileOutput.getLogFiles();
      if (logFiles.isEmpty) {
        _showSnackBar('鏆傛棤鏃ュ織鏂囦欢');
        return;
      }
      logFiles.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      final latestFile = logFiles.first;
      final fileBytes = await latestFile.readAsBytes();
      final filename = latestFile.path.split(Platform.pathSeparator).last;

      // 璁惧淇℃伅
      final deviceInfoResult = await DeviceInfoService.collectBasicDeviceInfo();
      final deviceInfoJson = deviceInfoResult['status'] == 'success'
          ? jsonEncode(deviceInfoResult['device_info'])
          : '{}';

      final reportUrl = XBoardConfig.reportLogUrl;
      if (reportUrl == null || reportUrl.isEmpty) {
        _showSnackBar('鏈厤缃棩蹇椾笂鎶ユ湇鍔″櫒鍦板潃');
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
        _showSnackBar('鏃ュ織涓婃姤鎴愬姛 鉁?);
      } else {
        _showSnackBar('鏃ュ織涓婃姤澶辫触');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('涓婃姤寮傚父: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  /// 鏄剧ず SnackBar 鎻愮ず
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
  Widget _buildUsageGrid(BuildContext context, double availableHeight) {
    final spacing = 14.0;
    // 鍜屼华琛ㄧ洏涓€鏍峰熀浜庡搴︾畻鍒楁暟锛屾瘡 280px 涓轰竴缁勶紙4鍒楋級锛岃嚦灏?8 鍒?
    final screenWidth = MediaQuery.of(context).size.width;
    final columns = max(4 * ((screenWidth / 280).ceil()), 8);
    return Consumer(
      builder: (context, ref, child) {
        // 鐩存帴 watch provider锛堜笉瑕佺敤 ref.userInfo 鎵╁睍锛屽畠鐢ㄧ殑鏄?read锛?
        final userInfo = ref.watch(userInfoProvider);
        final subscriptionInfo = ref.watch(subscriptionInfoProvider);
        final currentProfile = ref.watch(currentProfileProvider);
        return Grid(
          crossAxisCount: columns,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          children: [
            GridItem(
              crossAxisCellCount: columns,
              child: SubscriptionUsageCard(
                subscriptionInfo: subscriptionInfo,
                userInfo: userInfo,
                profileSubscriptionInfo: currentProfile?.subscriptionInfo,
              ),
            ),
          ],
        );
      },
    );
  }
  /// 绛夊緟璁㈤槄瀵煎叆瀹屾垚鍚庡啀妫€鏌ヨ闃呯姸鎬侊紙澶囩敤鏂规锛?
  /// 濡傛灉3绉掑悗杩樻病鏈夎Е鍙戝鍏ュ畬鎴愮洃鍚櫒锛屽垯涓诲姩妫€鏌?
  void _waitForSubscriptionImportThenCheck() async {
    await Future.delayed(const Duration(seconds: 3));

    // 濡傛灉宸茬粡閫氳繃鐩戝惉鍣ㄦ鏌ヨ繃浜嗭紝灏变笉鍐嶆鏌?
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
              // 鍏堝叧闂璇濇
              if (context.mounted) {
                Navigator.of(context).pop();
              }
              // 娓呴櫎閿欒鐘舵€?
              userNotifier.clearTokenExpiredError();
              // 澶勭悊 Token 杩囨湡锛堟竻闄ゆ暟鎹級
              await userNotifier.handleTokenExpired();
              // 瀵艰埅鍒扮櫥褰曢〉
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
        // 蹇界暐鍙兘鐨?StateError
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