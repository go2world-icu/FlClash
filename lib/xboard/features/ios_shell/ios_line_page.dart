import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/ui/icons/icons.dart';
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

  Future<void> _testLines(IosManagedLines lines) async {
    if (_testing) return;
    setState(() => _testing = true);
    try {
      await ref
          .read(flClashGatewayProvider)
          .testProxies(lines.options, iosManagedProbeUrl);
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
    } finally {
      if (mounted) setState(() => _changing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lines = ref.watch(iosManagedLinesProvider);
    final connected = ref.watch(iosTunnelStatusProvider) == 'connected';
    final map = ref.watch(selectedMapProvider);
    final visible = lines?.options ?? const [];
    final selected = lines?.group.getCurrentSelectedName(
      map[lines.group.name] ?? '',
    );
    return material.Scaffold(
      backgroundColor: SurfaceLevel.page.colorOf(context.colorScheme),
      appBar: material.AppBar(
        backgroundColor: SurfaceLevel.page.colorOf(context.colorScheme),
        title: Text(context.iosMemberStrings.managedLines),
      ),
      body: SafeArea(
        top: false,
        child: PrismListView(
          padding: const EdgeInsets.all(16),
          itemCount: visible.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visible.isEmpty && connected
                          ? context.iosMemberStrings.noSelectableLines
                          : visible.isEmpty
                          ? context.iosMemberStrings.connectToLoadLines
                          : context.iosMemberStrings.chooseLine,
                      style: AppTextStyle.subheadline.of(context),
                    ),
                    if (lines != null)
                      TextButton(
                        onPressed: _testing ? null : () => _testLines(lines),
                        child: Text(
                          _testing
                              ? context.iosMemberStrings.testingLines
                              : context.iosMemberStrings.testLines,
                        ),
                      ),
                  ],
                ),
              );
            }
            final proxy = visible[index - 1];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Consumer(
                builder: (context, ref, _) {
                  final delay = ref.watch(
                    delayProvider(
                      proxyName: proxy.name,
                      testUrl: iosManagedProbeUrl,
                    ),
                  );
                  return Card(
                    isSelected: selected == proxy.name,
                    onPressed: _changing
                        ? null
                        : () => _select(lines!, proxy.name),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        const GlyphIcon(XBoardGlyphs.router),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            proxy.name,
                            style: AppTextStyle.body.of(context),
                          ),
                        ),
                        if (delay != null && delay > 0) ...[
                          const SizedBox(width: 8),
                          Text(
                            '$delay ms',
                            style: AppTextStyle.footnote.of(context),
                          ),
                        ],
                        const SizedBox(width: 8),
                        if (selected == proxy.name) const SelectionCheck(),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
