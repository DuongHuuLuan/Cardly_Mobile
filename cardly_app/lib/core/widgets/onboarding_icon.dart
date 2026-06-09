import 'package:flutter/material.dart';

class OnboardingIcon extends StatelessWidget {
  final IconData icon;
  final double containerSize;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;
  final BoxShape shape;
  final double borderRadius;
  const OnboardingIcon({
    super.key,
    required this.icon,
    this.containerSize = 160,
    this.iconSize = 80,
    this.backgroundColor = const Color(0x1A757575),
    this.iconColor = Colors.blueGrey,
    this.shape = BoxShape.circle,
    this.borderRadius = 0,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(borderRadius)
            : null,
      ),
      child: Icon(icon, size: iconSize, color: iconColor),
    );
  }
}
