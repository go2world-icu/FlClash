import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/widgets.dart' show ListItem;
import 'package:fl_clash/core/ios_lifecycle.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/xboard/adapter/flclash_gateway.dart';
import 'package:fl_clash/xboard/icons/xboard_glyphs.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prism_ui/prism_ui.dart';

import 'ios_managed_connection.dart';
import 'ios_member_strings.dart';

class IosLinePage extends ConsumerStatefulWidget {
  const IosLinePage({super.key});

  @override
  ConsumerState<IosLinePage> createState() => _IosLinePageState();
}

class _IosLinePageState extends ConsumerState<IosLinePage> {
  bool _changing = false;
  bool _testing = false;
  bool _tested = false;
  String _query = '';
  ({String group, String name})? _draft;

  Future<void> _testLines(List<Proxy> lines) async {
    if (_testing) return;
    setState(() {
      _testing = true;
      _tested = false;
    });
    try {
      await ref
          .read(flClashGatewayProvider)
          .testProxies(lines, iosManagedProbeUrl);
      if (mounted) setState(() => _tested = true);
    } catch (_) {
      if (mounted) _showTestFailure();
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  Future<void> _select(IosManagedLines lines, String proxy) async {
    if (_changing) return;
    setState(() => _changing = true);
    try {
      await ref
          .read(flClashGatewayProvider)
          .selectProxy(groupName: lines.group.name, proxyName: proxy);
      if (mounted &&
          ModalRoute.of(context)?.isCurrent == true &&
          ref.read(iosSelectedLineProvider) == proxy) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        dialogs.showBanner(
          context.iosMemberStrings.lineChangeFailed,
          level: BannerLevel.error,
        );
      }
    } finally {
      if (mounted) setState(() => _changing = false);
    }
  }

  void _showTestFailure() => dialogs.showBanner(
    context.iosMemberStrings.lineTestFailed,
    level: BannerLevel.error,
  );

  @override
  Widget build(BuildContext context) {
    final lines = ref.watch(iosManagedLinesProvider);
    final connected = ref.watch(iosTunnelStatusProvider) == 'connected';
    final options = lines?.options ?? const <Proxy>[];
    final visible = _query.isEmpty
        ? options
        : options
              .where((line) => line.name.toLowerCase().contains(_query))
              .toList();
    final current = ref.watch(iosSelectedLineProvider);
    final selected = _draft?.group == lines?.group.name
        ? _draft?.name ?? current
        : current;
    final canApply =
        lines != null &&
        selected != null &&
        selected != current &&
        options.any((line) => line.name == selected);
    final strings = context.iosMemberStrings;
    return KeyboardInsetHold(
      child: material.Scaffold(
        backgroundColor: SurfaceLevel.page.colorOf(context.colorScheme),
        appBar: material.AppBar(
          backgroundColor: SurfaceLevel.page.colorOf(context.colorScheme),
          title: Text(strings.managedLines),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (options.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: SearchField(
                    hintText: strings.searchLines,
                    onChanged: (value) =>
                        setState(() => _query = value.trim().toLowerCase()),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        options.isEmpty
                            ? connected
                                  ? strings.noSelectableLines
                                  : strings.connectToLoadLines
                            : strings.lineCount(visible.length),
                        style: AppTextStyle.subheadline.of(context),
                      ),
                    ),
                    if (options.isNotEmpty)
                      Flexible(
                        flex: 2,
                        child: TextButton(
                          onPressed: _testing || !connected
                              ? null
                              : () => _testLines(options),
                          child: Text(
                            _testing ? strings.testingLines : strings.testLines,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (options.isNotEmpty && visible.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(strings.noMatchingLines),
                ),
              Expanded(
                child: PrismListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: visible.length,
                  itemBuilder: (context, index) {
                    final proxy = visible[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: _IosLineRow(
                        key: ValueKey(proxy.name),
                        proxy: proxy,
                        selected: selected == proxy.name,
                        onSelect: _changing || !connected
                            ? null
                            : () => setState(() {
                                _draft = (
                                  group: lines!.group.name,
                                  name: proxy.name,
                                );
                              }),
                        onRetest: _testing || !connected
                            ? null
                            : () => _testLines([proxy]),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Text(
                  !connected
                      ? strings.linesDisconnectedHint
                      : _testing
                      ? strings.linesTestingHint
                      : _tested
                      ? strings.linesTestedHint
                      : strings.lineTestHint,
                  style: AppTextStyle.footnote.of(context),
                ),
              ),
              if (options.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: FilledButton(
                    onPressed: _changing || !connected || !canApply
                        ? null
                        : () => _select(lines, selected),
                    child: Text(strings.useLine),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IosLineRow extends ConsumerWidget {
  const _IosLineRow({
    super.key,
    required this.proxy,
    required this.selected,
    required this.onSelect,
    required this.onRetest,
  });

  final Proxy proxy;
  final bool selected;
  final VoidCallback? onSelect;
  final VoidCallback? onRetest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final delay = ref.watch(
      delayProvider(proxyName: proxy.name, testUrl: iosManagedProbeUrl),
    );
    final phase = ref.watch(
      delayTestPhaseProvider(
        proxyName: proxy.name,
        testUrl: iosManagedProbeUrl,
      ),
    );
    final app = context.appLocalizations;
    final strings = context.iosMemberStrings;
    final label = proxy.type == 'URLTest' || proxy.type == 'Fallback'
        ? strings.autoLineHint
        : phase != null
        ? strings.testingLines
        : delay == null
        ? strings.lineNotTested
        : delay > 0
        ? '$delay ms'
        : delay == delayTimedOutValue
        ? strings.lineTimeout
        : delayFailureText(delay, app);
    return Card(
      isSelected: selected,
      child: Row(
        children: [
          Expanded(
            child: ListItem<void>(
              onTap: onSelect,
              leading: const GlyphIcon(XBoardGlyphs.router),
              title: Text(proxy.name),
              subtitle: Text(label),
              trailing: selected ? const SelectionCheck() : null,
            ),
          ),
          IconButton(
            tooltip: app.delayTest,
            onPressed: phase == null ? onRetest : null,
            icon: const GlyphIcon(AppGlyphs.refresh),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
