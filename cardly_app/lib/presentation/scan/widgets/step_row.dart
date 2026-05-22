import 'package:flutter/material.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';

class StepRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String status;
  final bool isDotIcon;

  const StepRow({
    super.key,
    required this.icon,
    required this.title,
    required this.status,
    this.isDotIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor = AppColor.grey;
    Color textColor = AppColor.black;
    Color badgeBgColor = AppColor.greyLight;
    Color badgeTextColor = AppColor.greyDark;

    if (status == "Done") {
      iconColor = AppColor.primary;
      badgeBgColor = AppColor.greyLight;
      badgeTextColor = AppColor.black87;
    } else if (status == "In Progress") {
      iconColor = AppColor.primary;
      badgeBgColor = AppColor.primary.withValues(alpha: 0.1);
      badgeTextColor = AppColor.primary;
    } else if (status == "Pending") {
      iconColor = AppColor.grey;
      textColor = AppColor.grey;
      badgeBgColor = AppColor.greyLight.withValues(alpha: 0.5);
      badgeTextColor = AppColor.grey;
    }

    return Row(
      children: [
        isDotIcon && status == "In Progress"
            ? Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColor.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.circle, size: 10, color: AppColor.primary),
                ),
              )
            : Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: badgeBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: badgeTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
