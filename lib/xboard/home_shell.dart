import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/pages/home.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prism_ui/prism_ui.dart';

import 'config_check.dart';
import 'features/dashboard/widgets/start_button.dart';

class XBoardShellHome extends ConsumerWidget {
  const XBoardShellHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAccessory =
        hasXboardConfig &&
        ref.watch(shownPageLabelProvider) == PageLabel.dashboard &&
        ref.watch(profilesProvider.select((profiles) => profiles.isNotEmpty));
    final dockHeight = NavigationDock.heightOf(context);
    return HomePage(
      dockAccessory: showAccessory
          ? Padding(
              padding: EdgeInsetsDirectional.only(
                start: 8,
                end: 21,
                bottom: NavigationDock.insetOf(context) - dockHeight,
              ),
              child: StartButton(dockHeight: dockHeight),
            )
          : null,
    );
  }
}
