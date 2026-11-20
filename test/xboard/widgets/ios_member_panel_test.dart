import 'dart:io';

import 'package:fl_clash/core/core.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/plugins/ios_service.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/qr_code.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/xboard/xboard_material_theme.dart';
import 'package:fl_clash/xboard/domain/domain.dart';
import 'package:fl_clash/xboard/features/auth/models/auth_state.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/invite/providers/invite_provider.dart';
import 'package:fl_clash/xboard/features/ios_shell/ios_home_tab.dart';
import 'package:fl_clash/xboard/features/ios_shell/ios_health_tab.dart';
import 'package:fl_clash/xboard/features/ios_shell/ios_line_page.dart';
import 'package:fl_clash/xboard/features/ios_shell/ios_managed_connection.dart';
import 'package:fl_clash/xboard/features/ios_shell/ios_shell_page.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';
import 'package:fl_clash/xboard/features/notice/notice.dart';
import 'package:fl_clash/xboard/features/profile/models/import_models.dart';
import 'package:fl_clash/xboard/features/profile/providers/profile_import_provider.dart';
import 'package:fl_clash/xboard/services/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/common_button.dart';
import 'package:prism_ui/prism_ui.dart' as prism;
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../helpers/app_paths.dart';
import '../../helpers/test_app.dart';
import '../support/xboard_provider_fakes.dart';
import '../support/xboard_support.dart';

const _email = 'member@example.test';
const _member = UserAuthState(
  isAuthenticated: true,
  isInitialized: true,
  email: _email,
);
const _plan = DomainSubscription(
  subscribeUrl: 'https://toworld.example.test/subscribe',
  email: _email,
  uuid: 'test',
  planId: 1,
  planName: 'Member Plan',
  transferLimit: 10 * 1024 * 1024 * 1024,
  uploadedBytes: 0,
  downloadedBytes: 2 * 1024 * 1024 * 1024,
);

class _Core extends Mock implements CoreHandlerInterface {}

class _ImportNotifier extends ProfileImportNotifier {
  void fail() => state = const ImportState(status: ImportStatus.failed);
}

class _MemberInviteNotifier extends FakeInviteNotifier {
  _MemberInviteNotifier()
    : super(
        InviteState(
          inviteData: const DomainInvite(
            codes: [DomainInviteCode(code: 'TO+WORLD')],
            stats: InviteStats(availableCommission: 48),
          ),
          commissionHistory: [
            DomainCommission(
              id: 1,
              tradeNo: 'TW01',
              amount: 24,
              createdAt: DateTime(2026),
            ),
          ],
          hasMoreHistory: false,
        ),
      );

  @override
  Future<void> loadInviteData() async {}

  @override
  Future<void> refreshCommissionHistory() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => AppLocalizations.load(const Locale('en')));

  for (final mode in [prism.ThemeMode.light, prism.ThemeMode.dark]) {
    testWidgets('member navigation stays readable in ${mode.name} mode', (
      tester,
    ) async {
      globalState.packageInfo = PackageInfo(
        appName: 'ToWorld',
        packageName: 'com.toworld',
        version: '0.9.4',
        buildNumber: '2026111904',
      );
      var selectedLine = 'Hong Kong 01';
      await tester.pumpWidget(
        TestApp(
          themeMode: mode,
          overrides: [
            ...xboardBaseOverrides(),
            xboardUserProvider.overrideWith(
              () => FakeUserAuthNotifier(_member),
            ),
            subscriptionInfoProvider.overrideWithBuild((_, _) => _plan),
            iosManagedProfileProvider.overrideWith((_) => null),
            iosSelectedLineProvider.overrideWith((_) => selectedLine),
            inviteProvider.overrideWith(_MemberInviteNotifier.new),
          ],
          child: const XBoardMaterialTheme(child: XBoardIosShell()),
        ),
      );
      await tester.pumpAndSettle();
      final container = ProviderScope.containerOf(
        tester.element(find.byType(XBoardIosShell)),
      );
      Finder flag(String value) => find.byWidgetPredicate(
        (widget) => widget is prism.EmojiText && widget.text == value,
      );
      expect(flag('🇭🇰'), findsOneWidget);
      selectedLine = 'Singapore 01';
      container.invalidate(iosSelectedLineProvider);
      await tester.pumpAndSettle();
      expect(flag('🇭🇰'), findsNothing);
      expect(flag('🇸🇬'), findsOneWidget);

      void expectReadableBar(String title) {
        final titleContext = tester.element(find.text(title));
        final colors = prism.Theme.of(titleContext).colorScheme;
        final titleColor = DefaultTextStyle.of(titleContext).style.color!;
        final back = find.descendant(
          of: find.byTooltip('Back'),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is GlyphIcon && widget.glyph == AppGlyphs.arrowBack,
          ),
        );
        expect(titleColor, colors.onSurface);
        expect(IconTheme.of(tester.element(back)).color, colors.onSurface);
        final foreground = titleColor.computeLuminance();
        final background = prism.SurfaceLevel.page
            .colorOf(colors)
            .computeLuminance();
        final contrast = foreground > background
            ? (foreground + 0.05) / (background + 0.05)
            : (background + 0.05) / (foreground + 0.05);
        expect(contrast, greaterThanOrEqualTo(4.5));
      }

      await tester.tap(find.text('Singapore 01'));
      await tester.pumpAndSettle();
      expectReadableBar('Managed lines');
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('My'));
      await tester.pumpAndSettle();
      final app = AppLocalizations.of(
        tester.element(find.byType(XBoardIosShell)),
      );
      for (final (choice, expected) in [
        (app.dark, prism.ThemeMode.dark),
        (app.light, prism.ThemeMode.light),
        (app.auto, prism.ThemeMode.system),
      ]) {
        await tester.ensureVisible(find.text(app.themeMode));
        await tester.tap(find.text(app.themeMode));
        await tester.pumpAndSettle();
        await tester.tap(find.text(choice).last);
        await tester.pumpAndSettle();
        expect(container.read(themeSettingProvider).themeMode, expected);
      }
      await tester.ensureVisible(find.text('Invite and earn'));
      await tester.tap(find.text('Invite and earn'));
      await tester.pumpAndSettle();
      expectReadableBar('Invite and earn');
      await tester.tap(find.text('Commission details'));
      await tester.pumpAndSettle();
      expectReadableBar('Commission details');
      expect(tester.takeException(), isNull);
    });
  }

  test('only an owned or matching stored subscription can start', () async {
    final home = await Directory.systemTemp.createTemp('toworld-ios-panel');
    addTearDown(() => home.delete(recursive: true));
    await useAppPaths(home);
    const manual = Profile(
      id: 11,
      autoUpdateDuration: Duration.zero,
      url: 'https://unrelated.example.test/profile',
    );
    final file = await manual.file;
    await file.parent.create(recursive: true);
    await file.writeAsString('proxies: []');
    final storage = XBoardStorageService(FakeStorage());

    Future<Profile?> verifiedProfile() async {
      final container = ProviderContainer(
        overrides: [
          storageServiceProvider.overrideWithValue(storage),
          xboardUserProvider.overrideWith(() => FakeUserAuthNotifier(_member)),
          subscriptionInfoProvider.overrideWithBuild((_, _) => _plan),
          currentProfileProvider.overrideWithValue(manual),
        ],
      );
      final listener = container.listen(iosManagedProfileProvider, (_, _) {});
      try {
        return await container.read(iosManagedProfileProvider.future);
      } finally {
        listener.close();
        container.dispose();
      }
    }

    expect(await verifiedProfile(), isNull);
    await storage.setOwnedProfileIds('someone-else@example.test', [manual.id]);
    expect(await verifiedProfile(), isNull);
    await storage.setOwnedProfileIds(_email, [manual.id]);
    expect(await verifiedProfile(), manual);
    await file.writeAsString('');
    expect(await verifiedProfile(), isNull);
    await file.delete();
    expect(await verifiedProfile(), isNull);
    expect(await file.exists(), isFalse);
  });

  test(
    'automatic lines and nodes are offered without direct or policy groups',
    () {
      const node = Proxy(name: 'Hong Kong', type: 'Shadowsocks');
      const automatic = Proxy(name: 'Fastest', type: 'URLTest');
      const direct = Proxy(name: 'DIRECT', type: 'Direct');
      const global = Group(
        name: 'GLOBAL',
        type: GroupType.Selector,
        all: [node],
      );
      const group = Group(
        name: 'ToWorld',
        type: GroupType.Selector,
        all: [automatic, node, direct],
      );
      const autoGroup = Group(
        name: 'Fastest',
        type: GroupType.URLTest,
        all: [node],
      );

      final lines = iosManagedLines([global, group, autoGroup]);
      expect(lines?.group, group);
      expect(lines?.options, [automatic, node]);
      expect(hasActiveIosPlan(_plan, null), isTrue);
      expect(
        hasActiveIosPlan(
          _plan.copyWith(downloadedBytes: _plan.transferLimit),
          null,
        ),
        isFalse,
      );
    },
  );

  testWidgets('shows the member home and keeps a manual profile disconnected', (
    tester,
  ) async {
    await pumpXboard(
      tester,
      const XBoardIosShell(),
      overrides: [
        ...xboardBaseOverrides(),
        xboardUserProvider.overrideWith(() => FakeUserAuthNotifier(_member)),
        subscriptionInfoProvider.overrideWithBuild((_, _) => _plan),
        noticeProvider.overrideWith(
          () => FakeNoticeNotifier(const NoticeState()),
        ),
        iosManagedProfileProvider.overrideWith((_) => null),
        currentProfileProvider.overrideWithValue(null),
        selectedMapProvider.overrideWithValue(const {}),
        initProvider.overrideWithBuild((_, _) => true),
      ],
    );
    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    expect(find.text('Member Plan'), findsOneWidget);
    expect(find.text('8.00 GB'), findsOneWidget);
    final connect = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Connect'),
    );
    expect(connect.onPressed, isNull);

    await tester.tap(find.text('Connection health'));
    await tester.pumpAndSettle();
    expect(find.text('Waiting for the VPN'), findsOneWidget);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(XBoardIosShell)),
    );
    container.read(iosTunnelStatusProvider.notifier).update('connected');
    await tester.pumpAndSettle();
    expect(find.text('Select a managed line to check'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 10));
  });

  testWidgets('shows notices and keeps refresh available after a sync', (
    tester,
  ) async {
    const profile = Profile(id: 12, autoUpdateDuration: Duration.zero);
    await pumpXboard(
      tester,
      const XBoardIosShell(),
      overrides: [
        ...xboardBaseOverrides(),
        xboardUserProvider.overrideWith(() => FakeUserAuthNotifier(_member)),
        subscriptionInfoProvider.overrideWithBuild((_, _) => _plan),
        iosManagedProfileProvider.overrideWith((_) => profile),
        currentProfileProvider.overrideWithValue(profile),
        initProvider.overrideWithBuild((_, _) => true),
        noticeProvider.overrideWith(
          () => FakeNoticeNotifier(
            NoticeState(
              notices: [
                DomainNotice(
                  id: 1,
                  title: 'Service notice',
                  content: 'Maintenance is scheduled.',
                  createdAt: DateTime(2026),
                  updatedAt: DateTime(2026),
                ),
              ],
            ),
          ),
        ),
        profileImportProvider.overrideWith(_ImportNotifier.new),
      ],
    );
    final refresh = find.widgetWithText(
      TextButton,
      'Refresh membership and configuration',
    );
    expect(find.text('Service notice', findRichText: true), findsOneWidget);
    expect(tester.widget<TextButton>(refresh).onPressed, isNotNull);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(XBoardIosShell)),
    );
    (container.read(profileImportProvider.notifier) as _ImportNotifier).fail();
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Could not sync the membership configuration. Try refreshing again.',
      ),
      findsOneWidget,
    );
    expect(tester.widget<TextButton>(refresh).onPressed, isNotNull);
  });

  testWidgets(
    'managed sign-in asks the member to read the privacy information',
    (tester) async {
      await pumpXboard(
        tester,
        const XBoardIosShell(),
        overrides: [
          ...xboardBaseOverrides(),
          xboardUserProvider.overrideWith(
            () =>
                FakeUserAuthNotifier(const UserAuthState(isInitialized: true)),
          ),
        ],
      );
      tester.view.physicalSize = const Size(390, 844);
      await tester.pumpAndSettle();
      final signIn = find.widgetWithText(
        material.FilledButton,
        'Sign in and sync',
      );
      expect(tester.widget<material.FilledButton>(signIn).onPressed, isNull);
      await tester.tap(find.byType(material.Checkbox));
      await tester.pumpAndSettle();
      expect(tester.widget<material.FilledButton>(signIn).onPressed, isNotNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 10));
    },
  );

  testWidgets('opens the member website and shows read-only commissions', (
    tester,
  ) async {
    globalState.packageInfo = PackageInfo(
      appName: 'ToWorld',
      packageName: 'com.toworld',
      version: '0.9.4',
      buildNumber: '2026111901',
    );
    const channel = MethodChannel('plugins.flutter.io/url_launcher');
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    final calls = <MethodCall>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return true;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
    final website = Uri.parse('https://example.test/');

    await pumpXboard(
      tester,
      const XBoardIosShell(),
      overrides: [
        ...xboardBaseOverrides(),
        xboardUserProvider.overrideWith(() => FakeUserAuthNotifier(_member)),
        subscriptionInfoProvider.overrideWithBuild(
          (_, _) => _plan.copyWith(
            expiredAt: DateTime.now().add(const Duration(days: 8)),
          ),
        ),
        iosMembershipWebsiteProvider.overrideWithValue(website),
        iosManagedProfileProvider.overrideWith((_) => null),
        inviteProvider.overrideWith(_MemberInviteNotifier.new),
      ],
    );
    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    final connectionBackground = tester
        .widgetList<DecoratedBox>(
          find.ancestor(
            of: find.text('Not connected'),
            matching: find.byType(DecoratedBox),
          ),
        )
        .map((box) => box.decoration)
        .whereType<ShapeDecoration>()
        .firstWhere((decoration) => decoration.gradient != null)
        .gradient;
    await tester.tap(find.text('Renew on website'));
    await tester.pumpAndSettle();
    expect(calls.single.method, 'launch');
    expect(calls.single.arguments['url'], website.toString());
    expect(calls.single.arguments['useWebView'], false);
    expect(find.text('Member Plan'), findsOneWidget);

    await tester.tap(find.text('My'));
    await tester.pumpAndSettle();
    expect(find.text('Renew on website'), findsOneWidget);
    await tester.tap(find.text('Invite and earn'));
    await tester.pumpAndSettle();
    expect(find.text('¥48.00'), findsOneWidget);
    expect(find.text('TO+WORLD'), findsOneWidget);
    final commissionBackground = tester
        .widgetList<DecoratedBox>(
          find.ancestor(
            of: find.text('¥48.00'),
            matching: find.byType(DecoratedBox),
          ),
        )
        .map((box) => box.decoration)
        .whereType<ShapeDecoration>()
        .firstWhere((decoration) => decoration.gradient != null)
        .gradient;
    expect(commissionBackground, connectionBackground);
    expect(find.byType(material.BackButtonIcon), findsNothing);
    expect(find.text(xboardL10n.transferToWallet), findsNothing);
    expect(find.text(xboardL10n.withdrawCommission), findsNothing);
    await tester.tap(find.text('Share invitation'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<QrCodeView>(find.byType(QrCodeView)).data,
      'https://example.test/login#/register?code=TO%2BWORLD',
    );
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Commission details'));
    await tester.pumpAndSettle();
    expect(find.textContaining(xboardL10n.orderNumber('TW01')), findsOneWidget);
    expect(find.text('+¥24.00'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('TO+WORLD'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('About ToWorld'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('health checks the ToWorld endpoint and clears stale results', (
    tester,
  ) async {
    final core = _Core();
    var reachesExtension = false;
    const request = OutboundIpParams(
      proxyName: 'Hong Kong 01',
      urls: ['https://toworld.uk/cdn-cgi/trace'],
      timeout: 6000,
    );
    registerFallbackValue(request);
    when(() => core.outboundIp(any())).thenAnswer(
      (_) async => const OutboundIpResult(
        url: 'https://toworld.uk/cdn-cgi/trace',
        body: 'ip=203.0.113.24\nloc=HK\n',
        delay: 42,
      ),
    );
    const node = Proxy(name: 'Hong Kong 01', type: 'Shadowsocks');
    const singapore = Proxy(name: 'Singapore 01', type: 'Shadowsocks');
    const group = Group(
      name: 'ToWorld',
      type: GroupType.Selector,
      all: [node, singapore],
      now: 'Hong Kong 01',
    );
    const profile = Profile(id: 42, autoUpdateDuration: Duration.zero);
    await pumpXboard(
      tester,
      const XBoardIosShell(),
      overrides: [
        ...xboardBaseOverrides(),
        xboardUserProvider.overrideWith(() => FakeUserAuthNotifier(_member)),
        subscriptionInfoProvider.overrideWithBuild((_, _) => _plan),
        iosManagedProfileProvider.overrideWith((_) => profile),
        currentProfileProvider.overrideWithValue(profile),
        selectedMapProvider.overrideWithValue(const {}),
        iosManagedLinesProvider.overrideWith(
          (_) => (group: group, options: [node, singapore]),
        ),
        iosCoreChannelProvider.overrideWith((_) async => reachesExtension),
        iosCoreBootProvider.overrideWith(
          (_) async =>
              const IosCoreState(booted: true, tunStarted: true, error: ''),
        ),
        coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
      ],
    );
    tester.view.physicalSize = const Size(390, 844);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(XBoardIosShell)),
    );
    container.read(iosTunnelStatusProvider.notifier).update('connected');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hong Kong 01'));
    await tester.pumpAndSettle();
    expect(find.byType(IosLinePage), findsOneWidget);
    expect(find.text('Test line response times'), findsOneWidget);
    expect(
      tester
          .getRect(find.widgetWithText(TextButton, 'Test line response times'))
          .right,
      closeTo(tester.getRect(find.byType(IosLinePage)).right - 16, 1),
    );
    expect(find.text('Singapore 01'), findsOneWidget);
    final search = tester.widget<prism.SearchField>(
      find.byType(prism.SearchField),
    );
    final pageColors = prism.Theme.of(
      tester.element(find.byType(IosLinePage)),
    ).colorScheme;
    expect(search.fill, isNotNull);
    expect(search.fill, isNot(prism.SurfaceLevel.page.colorOf(pageColors)));
    expect(
      find.byWidgetPredicate(
        (widget) => widget is prism.EmojiText && widget.text == '🇭🇰',
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is prism.EmojiText && widget.text == '🇸🇬',
      ),
      findsOneWidget,
    );
    await tester.enterText(find.byType(EditableText), 'hong');
    await tester.pumpAndSettle();
    expect(find.text('Hong Kong 01'), findsOneWidget);
    expect(find.text('Singapore 01'), findsNothing);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is prism.EmojiText && widget.text == '🇸🇬',
      ),
      findsNothing,
    );
    Navigator.of(tester.element(find.byType(IosLinePage))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Connection health'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Check connection'), 250);
    await tester.drag(find.byType(IosHealthTab), const Offset(0, -180));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check connection'));
    await tester.pumpAndSettle();
    expect(find.text('VPN extension did not respond'), findsWidgets);
    verifyNever(() => core.outboundIp(any()));
    reachesExtension = true;
    await tester.scrollUntilVisible(find.text('Check again'), 100);
    await tester.tap(find.text('Check again'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Connection healthy'), -150);
    expect(find.text('Connection healthy'), findsOneWidget);
    expect(find.text('203.0.113.24'), findsOneWidget);
    expect(find.text('42 ms'), findsOneWidget);
    final calls = verify(() => core.outboundIp(captureAny())).captured;
    final called = calls.single as OutboundIpParams;
    expect(called.urls, request.urls);
    expect(called.proxyName, request.proxyName);
    container.read(iosTunnelStatusProvider.notifier).update('disconnected');
    await tester.pumpAndSettle();
    expect(find.text('203.0.113.24'), findsNothing);
    final activity = find.text('Recent connection activity');
    await tester.scrollUntilVisible(activity, 150);
    await tester.tap(activity);
    await tester.pumpAndSettle();
    expect(find.text('VPN connected'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 10));
  });

  testWidgets('Chinese member copy matches the approved prototype', (
    tester,
  ) async {
    await AppLocalizations.load(const Locale('zh', 'CN'));
    addTearDown(() => AppLocalizations.load(const Locale('en')));
    globalState.packageInfo = PackageInfo(
      appName: 'ToWorld',
      packageName: 'com.toworld',
      version: '0.9.4',
      buildNumber: '2026111902',
    );
    const profile = Profile(id: 42, autoUpdateDuration: Duration.zero);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      TestApp(
        locale: const Locale('zh', 'CN'),
        overrides: [
          ...xboardBaseOverrides(),
          xboardUserProvider.overrideWith(() => FakeUserAuthNotifier(_member)),
          subscriptionInfoProvider.overrideWithBuild((_, _) => _plan),
          iosManagedProfileProvider.overrideWith((_) => profile),
          currentProfileProvider.overrideWithValue(profile),
          initProvider.overrideWithBuild((_, _) => true),
          inviteProvider.overrideWith(_MemberInviteNotifier.new),
          iosMembershipWebsiteProvider.overrideWithValue(
            Uri.parse('https://example.test/'),
          ),
        ],
        child: const XBoardMaterialTheme(child: XBoardIosShell()),
      ),
    );
    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    expect(find.text('未连接'), findsOneWidget);
    expect(find.text('配置已同步，可以连接'), findsOneWidget);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(XBoardIosShell)),
    );
    container.read(iosTunnelStatusProvider.notifier).update('connected');
    await tester.pumpAndSettle();
    for (final text in [
      '连接已开启',
      'ToWorld VPN 正在运行',
      '断开连接',
      '上行',
      '下行',
      '连接时长',
    ]) {
      expect(find.text(text), findsOneWidget);
    }
    container.read(iosTunnelStatusProvider.notifier).update('disconnected');
    await tester.tap(find.text('连接健康'));
    await tester.pumpAndSettle();
    for (final text in [
      '等待连接',
      '账号与套餐',
      '托管配置',
      'VPN 隧道',
      '扩展通信',
      '内核启动',
      '先连接 VPN',
    ]) {
      await tester.scrollUntilVisible(find.text(text), 80);
      expect(find.text(text), findsOneWidget);
    }
    await tester.tap(find.text('我的'));
    await tester.pumpAndSettle();
    for (final text in ['我的账户', '官网续费', '邀请返佣', '连接诊断', '关于 ToWorld']) {
      expect(find.text(text), findsOneWidget);
    }
    await tester.tap(find.text('邀请返佣'));
    await tester.pumpAndSettle();
    for (final text in [
      '返佣规则',
      '可用佣金',
      '待结算',
      '累计佣金',
      '已邀请',
      '分享邀请',
      '复制链接',
      '佣金明细',
    ]) {
      expect(find.text(text), findsOneWidget);
    }
    await tester.tap(find.text('佣金明细'));
    await tester.pumpAndSettle();
    expect(find.text('邀请佣金'), findsOneWidget);
    expect(find.text('+¥24.00'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 10));
  });
}
