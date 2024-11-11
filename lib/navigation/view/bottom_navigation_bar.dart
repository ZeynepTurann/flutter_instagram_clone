import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final navigatonBarItems = mainNavigationBarItems(
        homeLabel: l10n.homeNavBarItemLabel,
        searchLabel: l10n.searchNavBarItemLabel,
        createMediaLabel: l10n.createMediaNavBarItemLabel,
        reelsLabel: l10n.reelsNavBarItemLabel,
        userProfileLabel: l10n.profileNavBarItemLabel,
        userProfileAvatar: const Icon(Icons.person));

    return BottomNavigationBar(
      currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        iconSize: 28,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: navigatonBarItems
            .map((e) => BottomNavigationBarItem(
                icon: e.child ?? Icon(e.icon),
                tooltip: e.tooltip,
                label: e.label))
            .toList());
  }
}
