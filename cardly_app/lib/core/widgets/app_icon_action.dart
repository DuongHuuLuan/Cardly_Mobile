import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:flutter/material.dart';

class AppIconAction extends StatelessWidget {
  final IconData icon;
  final String? label;
  final TextStyle? labelStyle;
  final VoidCallback? onTap;
  final double? iconSize;
  final double? containerSize;
  final Color? containerColor;
  final Color? iconColor;
  final double? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  const AppIconAction({
    super.key,
    required this.icon,
    this.label,
    this.onTap,
    this.iconSize = 28,
    this.containerSize = 64,
    this.containerColor,
    this.iconColor,
    this.labelStyle,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              color: containerColor ?? AppColor.grey.withValues(alpha: 0.08),
              shape: borderRadius != null
                  ? BoxShape.rectangle
                  : BoxShape.circle,
              borderRadius: borderRadius != null
                  ? BorderRadius.circular(borderRadius!)
                  : null,
              border: borderColor != null
                  ? Border.all(color: borderColor!, width: borderWidth ?? 1)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: iconSize,
                  color: iconColor ?? AppColor.primary,
                ),
                if (label != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    label!,
                    style:
                        labelStyle ??
                        AppTextStyles.bodySmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColor.greyDark,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
