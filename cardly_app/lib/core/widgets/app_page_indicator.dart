import 'package:cardly_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppPageIndicator extends StatelessWidget {
  final int currentIndex;
  final int count;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? activeWidth;
  final double? inactiveWidth;
  final double? height;
  final double? borderRadiusValue;
  final Duration? animationDuration;
  const AppPageIndicator({
    super.key,
    required this.currentIndex,
    required this.count,
    this.activeColor = AppColor.primary,
    this.inactiveColor = AppColor.greyLight,
    this.activeWidth = 24,
    this.inactiveWidth = 10,
    this.height = 10,
    this.borderRadiusValue = 5,
    this.animationDuration = const Duration(milliseconds: 300),
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == currentIndex;
        return AnimatedContainer(
          duration: animationDuration!,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? activeWidth : inactiveWidth,
          height: height,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(borderRadiusValue!),
          ),
        );
      }),
    );
  }
}
