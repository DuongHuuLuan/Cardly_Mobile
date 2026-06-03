import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_avatar.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:flutter/material.dart';

class AppContactCard extends StatelessWidget {
  final BusinessCardEntity contact;
  final VoidCallback? onTap;
  final double? radiusAvatar;
  final double? iconTrailingSize;
  final TextStyle? titleStyle;
  final TextStyle? subTileStyle;
  final Color? iconColor;
  const AppContactCard({
    super.key,
    required this.contact,
    this.onTap,
    this.radiusAvatar,
    this.iconTrailingSize,
    this.titleStyle,
    this.subTileStyle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: AppAvatar(
          name: contact.fullName ?? '',
          radius: radiusAvatar ?? 24,
        ),
        title: Text(
          contact.fullName ?? "Unknown",
          style:
              titleStyle ??
              AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          [
            if (contact.jobTitle != null && contact.jobTitle!.isNotEmpty)
              contact.jobTitle,
            if (contact.company != null && contact.company!.isNotEmpty)
              contact.company,
          ].join(' · '),
          style: subTileStyle ?? AppTextStyles.caption,
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: iconColor ?? AppColor.grey,
          size: iconTrailingSize ?? 22,
        ),
        onTap: onTap,
      ),
    ).paddingOnly(bottom: 10);
  }
}
