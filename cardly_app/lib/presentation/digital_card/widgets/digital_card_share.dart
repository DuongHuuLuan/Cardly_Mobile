import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:cardly_app/core/widgets/app_icon_action.dart';
import 'package:flutter/material.dart';

class DigitalCardShare extends StatelessWidget {
  final String? cardUrl;
  const DigitalCardShare({super.key, this.cardUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Share business cards",
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.greyLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Public link",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColor.greyDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(cardUrl!, style: AppTextStyles.bodySmall),
                  ],
                ),
                const Spacer(),
                AppIconAction(
                  icon: Icons.copy,
                  iconSize: 20,
                  onTap: () {},
                  iconColor: AppColor.grey,
                  containerSize: 45,
                  containerColor: AppColor.white,
                  borderColor: AppColor.greyLight,
                  borderRadius: 16,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: AppElevatedButton(
                  label: "Shared",
                  onPressed: () {},
                  labelStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColor.white,
                  ),
                  iconAfterText: false,
                  icon: Icon(Icons.share_outlined, color: AppColor.white),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppElevatedButton(
                  label: "QR Code",
                  onPressed: () {},
                  backgroundColor: AppColor.white,
                  labelStyle: AppTextStyles.bodyMedium,
                  icon: Icon(
                    Icons.qr_code_2,
                    color: AppColor.primary,
                    size: 18,
                  ),
                  borderColor: AppColor.grey.withValues(alpha: 0.7),
                ),
              ),
            ],
          ).paddingOnly(top: 12),
        ],
      ),
    );
  }
}
