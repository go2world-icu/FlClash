import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/xboard/features/invite/dialogs/theme_dialog.dart';
import 'package:fl_clash/xboard/features/invite/dialogs/logout_dialog.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';
import 'package:fl_clash/xboard/icons/xboard_glyphs.dart';

class UserMenuWidget extends ConsumerWidget {
  const UserMenuWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: const GlyphIcon(XBoardGlyphs.person),
      tooltip: xboardL10n.userCenter,
      onSelected: (value) {
        if (value == 'theme') {
          _showThemeDialog(context);
        } else if (value == 'logout') {
          _showLogoutDialog(context);
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'theme',
          child: Row(
            children: [
              const GlyphIcon(XBoardGlyphs.themeAuto),
              const SizedBox(width: 8),
              Text(xboardL10n.switchTheme),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              const GlyphIcon(XBoardGlyphs.logout, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                xboardL10n.logout,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const ThemeDialog());
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const LogoutDialog());
  }
}
