import 'package:material_ui/material_ui.dart';
import 'package:fl_clash/xboard/utils/xboard_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(xboardL10n.confirmLogout),
      content: Text(xboardL10n.logoutConfirmMsg),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(appLocalizations.cancel),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await _performLogout(context, ref);
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text(xboardL10n.logout),
        ),
      ],
    );
  }

  Future<void> _performLogout(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(xboardUserProvider.notifier).logout();
      if (context.mounted) {
        XBoardNotification.showSuccess(xboardL10n.loggedOutSuccess);
      }
    } catch (e) {
      if (context.mounted) {
        XBoardNotification.showError(
          xboardL10n.logoutFailed(e.toString()),
        );
      }
    }
  }
}
