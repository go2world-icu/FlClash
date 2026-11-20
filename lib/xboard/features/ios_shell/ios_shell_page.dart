import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/widgets.dart' show ListItem;
import 'package:fl_clash/xboard/features/auth/pages/login_page.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/initialization/initialization.dart';
import 'package:fl_clash/xboard/features/invite/providers/invite_provider.dart';
import 'package:fl_clash/xboard/icons/xboard_glyphs.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prism_ui/prism_ui.dart';

import 'ios_connection_activity.dart';
import 'ios_health_tab.dart';
import 'ios_home_tab.dart';
import 'ios_invite_page.dart';
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

class _IosMemberTabs extends ConsumerStatefulWidget {
  const _IosMemberTabs({super.key});

  @override
  ConsumerState<_IosMemberTabs> createState() => _IosMemberTabsState();
}

class _IosMemberTabsState extends ConsumerState<_IosMemberTabs> {
  int _selected = 0;
  bool _loadedInvite = false;

  void _selectTab(int index) {
    setState(() => _selected = index);
    if (index == 2 && !_loadedInvite) {
      _loadedInvite = true;
      unawaited(ref.read(inviteProvider.notifier).loadInviteData());
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(iosConnectionActivityProvider.notifier);
    final labels = [
      xboardL10n.xboardHome,
      context.iosMemberStrings.connectionHealth,
      context.iosMemberStrings.my,
    ];
    return material.Scaffold(
      backgroundColor: SurfaceLevel.page.colorOf(context.colorScheme),
      appBar: material.AppBar(
        foregroundColor: context.colorScheme.onSurface,
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
                _selected == 2
                    ? context.iosMemberStrings.accountTitle
                    : labels[_selected],
                style: AppTextStyle.title2.of(context, emphasized: true),
              ),
        actions: [
          if (_selected == 0)
            material.IconButton(
              tooltip: labels[2],
              onPressed: () => _selectTab(2),
              icon: const GlyphIcon(XBoardGlyphs.person),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: switch (_selected) {
          1 => const IosHealthTab(),
          2 => _IosAccountTab(
            onShowHealth: () => setState(() => _selected = 1),
          ),
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
          onSelected: _selectTab,
        ),
      ),
    );
  }
}

class _IosAccountTab extends ConsumerWidget {
  const _IosAccountTab({required this.onShowHealth});

  final VoidCallback onShowHealth;

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final strings = context.iosMemberStrings;
    final confirmed = await dialogs.showCommonDialog<bool>(
      context: context,
      child: Builder(
        builder: (context) => AlertDialog(
          title: strings.logoutTitle,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.appLocalizations.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(strings.confirmLogout),
            ),
          ],
          child: Text(strings.logoutHint),
        ),
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref.read(xboardUserProvider.notifier).logout();
    } catch (error) {
      if (context.mounted) {
        dialogs.showBanner(
          xboardL10n.logoutFailed(error.toString()),
          level: BannerLevel.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(xboardUserProvider.select((state) => state.email));
    final commission = ref.watch(
      inviteProvider.select(
        (state) =>
            state.hasInviteData ? state.formattedAvailableCommission : null,
      ),
    );
    final locale = ref.watch(
      appSettingProvider.select((state) => state.locale),
    );
    final app = context.appLocalizations;
    final themeMode = ref.watch(
      themeSettingProvider.select((state) => state.themeMode),
    );
    final strings = context.iosMemberStrings;
    final packageInfo = globalState.packageInfo;
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
                      strings.toworldMember,
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
        const IosMembershipCard(showDetails: true),
        const SizedBox(height: 12),
        Card(
          onPressed: () => Navigator.of(context).push<void>(
            PageRouteBuilder<void>(
              pageBuilder: (_, _, _) => const IosInvitePage(),
            ),
          ),
          child: ListRow(
            leading: const GlyphIcon(XBoardGlyphs.people),
            title: Text(strings.inviteRewards),
            subtitle: commission == null
                ? null
                : Text('${xboardL10n.availableCommission} · $commission'),
            trailing: const GlyphIcon(AppGlyphs.chevronForward),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListItem<ThemeMode>.options(
                leading: const GlyphIcon(AppGlyphs.sun),
                title: Text(app.themeMode),
                options: ThemeMode.values,
                value: themeMode,
                textBuilder: (mode) => switch (mode) {
                  ThemeMode.system => app.auto,
                  ThemeMode.light => app.light,
                  ThemeMode.dark => app.dark,
                },
                onChanged: (mode) => ref
                    .read(themeSettingProvider.notifier)
                    .update((state) => state.copyWith(themeMode: mode)),
              ),
              ListItem<Locale?>.options(
                leading: const GlyphIcon(AppGlyphs.language),
                title: Text(app.language),
                options: const [null, Locale('zh', 'CN'), Locale('en')],
                value: getLocaleForString(locale),
                textBuilder: (option) => switch (option?.languageCode) {
                  'zh' => '简体中文',
                  'en' => 'English',
                  _ => app.defaultText,
                },
                onChanged: (option) => ref
                    .read(appSettingProvider.notifier)
                    .update(
                      (state) => state.copyWith(locale: option?.toString()),
                    ),
              ),
              ListItem<void>(
                onTap: () => showIosMemberPrivacy(context),
                leading: const GlyphIcon(XBoardGlyphs.shieldCheck),
                title: Text(strings.privacy),
              ),
              ListItem<void>(
                onTap: onShowHealth,
                leading: const GlyphIcon(XBoardGlyphs.supportAgent),
                title: Text(strings.connectionDiagnosis),
              ),
              ListRow(
                leading: const GlyphIcon(XBoardGlyphs.accountBox),
                title: Text(strings.aboutToWorld),
                subtitle: Text(
                  '${packageInfo.version} (${packageInfo.buildNumber})',
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => _logout(context, ref),
          child: Text(xboardL10n.logout),
        ),
      ],
    );
  }
}
