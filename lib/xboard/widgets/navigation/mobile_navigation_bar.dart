import 'package:flutter/material.dart';
import 'package:fl_clash/l10n/l10n.dart';

/// 移动端底部导航栏
class MobileNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  const MobileNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    return NavigationBar(
      selectedIndex: selectedIndex,
      height: 60,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home, size: 22),
          label: '首页',
        ),
        NavigationDestination(
          icon: const Icon(Icons.people, size: 22),
          label: '邀请',
        ),
      ],
      onDestinationSelected: (index) => onDestinationSelected?.call(index),
    );
  }
}

