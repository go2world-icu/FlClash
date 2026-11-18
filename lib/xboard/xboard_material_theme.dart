import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:prism_ui/prism_ui.dart' as prism;

class XBoardMaterialTheme extends StatelessWidget {
  const XBoardMaterialTheme({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = prism.Theme.of(context).colorScheme;
    return material.Theme(
      data: material.ThemeData.from(
        colorScheme: material.ColorScheme.fromSeed(
          seedColor: colors.primary,
          brightness: colors.brightness,
          primary: colors.primary,
          onPrimary: colors.onPrimary,
          primaryContainer: colors.primaryContainer,
          onPrimaryContainer: colors.onPrimaryContainer,
          error: colors.error,
          onError: colors.onError,
          surface: colors.surface,
          onSurface: colors.onSurface,
        ),
      ),
      child: child,
    );
  }
}
