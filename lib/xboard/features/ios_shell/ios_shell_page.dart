import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/xboard/features/auth/pages/login_page.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/initialization/initialization.dart';
import 'package:fl_clash/xboard/features/invite/dialogs/logout_dialog.dart';
import 'package:fl_clash/xboard/features/invite/dialogs/theme_dialog.dart';
import 'package:fl_clash/xboard/icons/xboard_glyphs.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prism_ui/prism_ui.dart';

import 'ios_health_tab.dart';
import 'ios_home_tab.dart';
import 'ios_member_privacy.dart';
import 'ios_member_strings.dart';
import 'ios_splash_screen.dart';

class XBoardIosShell extends ConsumerWidget {
  const XBoardIosShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(xboardUserProvider);
    if (!user.isInitialized && !ref.watch(initializationProvider).isFailed) {
      return const IosSplashScreen();
    }
    if (!user.isAuthenticated) return const LoginPage(managedIos: true);
    return _IosMemberTabs(key: ValueKey(user.email));
  }
}

class _IosMemberTabs extends StatefulWidget {
  const _IosMemberTabs({super.key});

  @override
  State<_IosMemberTabs> createState() => _IosMemberTabsState();
}

class _IosMemberTabsState extends State<_IosMemberTabs> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final labels = [
      xboardL10n.xboardHome,
      context.iosMemberStrings.connectionHealth,
      context.appLocalizations.account,
    ];
    return material.Scaffold(
      backgroundColor: SurfaceLevel.page.colorOf(context.colorScheme),
      appBar: material.AppBar(
        backgroundColor: SurfaceLevel.page.colorOf(context.colorScheme),
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: _selected == 0
            ? Row(
                children: [
                  Image.asset('assets/images/icon.png', width: 34, height: 34),
                  const SizedBox(width: 8),
                  Text(
                    appName,
                    style: AppTextStyle.title2.of(context, emphasized: true),
                  ),
                ],
              )
            : Text(
                labels[_selected],
                style: AppTextStyle.title2.of(context, emphasized: true),
              ),
        actions: [
          if (_selected == 0)
            material.IconButton(
              tooltip: labels[2],
              onPressed: () => setState(() => _selected = 2),
              icon: const GlyphIcon(XBoardGlyphs.person),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: switch (_selected) {
          1 => const IosHealthTab(),
          2 => const _IosAccountTab(),
          _ => const IosHomeTab(),
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 6, 16, 5),
        child: NavigationDock(
          destinations: [
            NavigationDockDestination(
              glyph: XBoardGlyphs.home,
              label: labels[0],
            ),
            NavigationDockDestination(
              glyph: XBoardGlyphs.networkCheck,
              label: labels[1],
            ),
            NavigationDockDestination(
              glyph: XBoardGlyphs.person,
              label: labels[2],
            ),
          ],
          selectedIndex: _selected,
          onSelected: (index) => setState(() => _selected = index),
        ),
      ),
    );
  }
}

class _IosAccountTab extends ConsumerWidget {
  const _IosAccountTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(xboardUserProvider.select((state) => state.email));
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      children: [
        Card(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const GlyphIcon(XBoardGlyphs.person, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.iosMemberStrings.toworldMember,
                      style: AppTextStyle.headline.of(context),
                    ),
                    if (email != null)
                      Text(email, style: AppTextStyle.subheadline.of(context)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const IosMembershipCard(),
        const SizedBox(height: 12),
        Card(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                onPressed: () => showIosMemberPrivacy(context),
                child: Text(context.iosMemberStrings.privacy),
              ),
              TextButton(
                onPressed: () => material.showDialog<void>(
                  context: context,
                  builder: (_) => const ThemeDialog(),
                ),
                child: Text(context.appLocalizations.theme),
              ),
              TextButton(
                onPressed: () => material.showDialog<void>(
                  context: context,
                  builder: (_) => const LogoutDialog(),
                ),
                child: Text(xboardL10n.logout),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
