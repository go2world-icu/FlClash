import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/icons/icons.dart';
import 'package:fl_clash/xboard/features/invite/providers/invite_provider.dart';
import 'package:fl_clash/xboard/config/xboard_config.dart';
import 'package:fl_clash/xboard/features/invite/widgets/qr_code_widget.dart';
import 'package:fl_clash/xboard/utils/xboard_notification.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';

class InviteQrCard extends ConsumerWidget {
  const InviteQrCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inviteState = ref.watch(inviteProvider);

    final firstCode =
        inviteState.hasInviteData && inviteState.inviteData!.codes.isNotEmpty
        ? inviteState.inviteData!.codes.first
        : null;

    final baseUrl = _getSdkBaseUrl();
    final inviteUrl = firstCode != null && baseUrl.isNotEmpty
        ? '$baseUrl/login#/register?code=${firstCode.code}'
        : '';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              xboardL10n.myInviteQr,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            if (firstCode != null) ...[
              QrCodeWidget(data: inviteUrl, size: 200),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _saveQrCode(context, inviteUrl),
                    icon: const GlyphIcon(AppGlyphs.save),
                    label: Text(xboardL10n.saveQr),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _copyToClipboard(context, inviteUrl),
                    icon: const GlyphIcon(AppGlyphs.link),
                    label: Text(xboardL10n.copyInviteLink),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (inviteState.isLoading || inviteState.isGenerating) ...[
              Container(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      xboardL10n.generatingInviteCode,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    GlyphIcon(
                      AppGlyphs.error,
                      size: 64,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      xboardL10n.inviteCodeGenFailed,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      xboardL10n.checkNetwork,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    XBoardNotification.showSuccess(xboardL10n.copiedToClipboard);
  }

  void _saveQrCode(BuildContext context, String inviteUrl) {
    XBoardNotification.showInfo(xboardL10n.saveQrCodeFeature);
  }

  String _getSdkBaseUrl() {
    try {
      return XBoardConfig.panelUrl ?? '';
    } catch (e) {
      return '';
    }
  }
}
