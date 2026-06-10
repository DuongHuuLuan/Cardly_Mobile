import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});
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
              onPressed: () => context.goToHome(),
            ),
            _NavItem(
              // icon: Icons.search,
              isActive: currentIndex == 1,
              onPressed: () {},
            ),

            _NavItem(
              icon: Icons.people_outline,
              isActive: currentIndex == 2,
              onPressed: () => context.goToContact(),
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
