import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/icons/icons.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';

class ThemeDialog extends ConsumerWidget {
  const ThemeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.read(
      themeSettingProvider.select((state) => state.themeMode),
    );

    return AlertDialog(
      title: Text(xboardL10n.selectTheme),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<ThemeMode>(
            title: Row(
              children: [
                const GlyphIcon(AppGlyphs.themeAuto),
                const SizedBox(width: 8),
                Text(appLocalizations.auto),
              ],
            ),
            value: ThemeMode.system,
            groupValue: currentThemeMode,
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(themeSettingProvider.notifier)
                    .update((state) => state.copyWith(themeMode: value));
                Navigator.of(context).pop();
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: Row(
              children: [
                const GlyphIcon(AppGlyphs.sun),
                const SizedBox(width: 8),
                Text(appLocalizations.light),
              ],
            ),
            value: ThemeMode.light,
            groupValue: currentThemeMode,
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(themeSettingProvider.notifier)
                    .update((state) => state.copyWith(themeMode: value));
                Navigator.of(context).pop();
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: Row(
              children: [
                const GlyphIcon(AppGlyphs.moon),
                const SizedBox(width: 8),
                Text(appLocalizations.dark),
              ],
            ),
            value: ThemeMode.dark,
            groupValue: currentThemeMode,
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(themeSettingProvider.notifier)
                    .update((state) => state.copyWith(themeMode: value));
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(appLocalizations.cancel),
        ),
      ],
    );
  }
}
