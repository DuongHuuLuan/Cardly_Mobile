import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  void _goIfNeeded(BuildContext context, String routeName) {
    final currentLocation = GoRouterState.of(context).uri.toString();

    if (currentLocation == routeName) return;

    context.go(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10.0,
      color: AppColor.white,
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem(
              icon: Icons.credit_card_outlined,
              isActive: currentIndex == 0,
              onPressed: () => _goIfNeeded(context, HomePage.routerName),
            ),
            _NavItem(
              // icon: Icons.search,
              isActive: currentIndex == 1,
              onPressed: () {},
            ),

            _NavItem(
              icon: Icons.people_outline,
              isActive: currentIndex == 2,
              onPressed: () => _goIfNeeded(context, ContactScreen.routerName),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData? icon;
  final bool isActive;
  final VoidCallback onPressed;
  const _NavItem({this.icon, required this.isActive, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: isActive ? AppColor.primary : AppColor.black87),
    );
  }
}
