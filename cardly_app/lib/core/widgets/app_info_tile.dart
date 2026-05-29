import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:flutter/material.dart';

class AppInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final IconData? trailingIcon;
  final double? trailingIconSize;
  final Color? trailingIconColor;
  final double? iconSize;
  final Color? iconColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final VoidCallback? onTap;
  const AppInfoTile({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.iconColor,
    this.iconSize,
    this.trailingIcon,
    this.trailingIconColor,
    this.trailingIconSize,
    this.labelStyle,
    this.valueStyle,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final tile = Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: iconSize ?? 20, color: iconColor ?? AppColor.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      labelStyle ??
                      AppTextStyles.caption.copyWith(color: AppColor.grey),
                ),
                if (value != null && value!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(value!, style: valueStyle ?? AppTextStyles.bodyMedium),
                ],
              ],
            ),
          ),
          Icon(
            trailingIcon ?? Icons.chevron_right,
            size: trailingIconSize ?? 20,
            color: trailingIconColor ?? AppColor.grey,
          ),
        ],
      ),
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: tile,
      );
    }
    return tile;
  }
}
