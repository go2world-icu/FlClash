import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/views/dashboard/dashboard.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ios_shell/ios_core_status.dart';
import 'widgets/start_button.dart';

const _iosHiddenWidgets = {
  DashboardWidget.serviceStatus,
  DashboardWidget.intranetIp,
};

class XBoardDashboardView extends StatelessWidget {
  const XBoardDashboardView({super.key, this.platform});

  final SupportPlatform? platform;

  @override
  Widget build(BuildContext context) {
    final target = platform ?? SupportPlatform.currentPlatform;
    final isIOS = target == SupportPlatform.IOS;
    return DashboardView(
      platform: target,
      hiddenCards: isIOS ? _iosHiddenWidgets : const {},
      status: isIOS ? const IosCoreStatus(compact: true) : null,
      overlay: const _XBoardDashboardAction(),
    );
  }
}

class _XBoardDashboardAction extends ConsumerWidget {
  const _XBoardDashboardAction();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasProfile = ref.watch(
      profilesProvider.select((state) => state.isNotEmpty),
    );
    if (!hasProfile) {
      return const SizedBox.shrink();
    }
    final inDock =
        ref.watch(isMobileViewProvider) &&
        ref.watch(
          appSettingProvider.select((state) => state.floatingNavigationBar),
        );
    if (inDock) {
      return const SizedBox.shrink();
    }
    return const StartButton();
  }
}
