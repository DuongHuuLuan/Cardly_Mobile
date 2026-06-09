import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:flutter/material.dart';

class DigitalCardPreview extends StatelessWidget {
  final String name;
  final String position;
  final String company;
  final VoidCallback? onViewDetail;
  const DigitalCardPreview({
    super.key,
    required this.name,
    required this.position,
    required this.company,
    this.onViewDetail,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.206,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.credit_card_outlined,
                color: AppColor.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "My business card number",
                style: AppTextStyles.caption.copyWith(color: AppColor.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColor.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "$position · $company",
            style: AppTextStyles.bodyMedium.copyWith(color: AppColor.grey),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColor.white54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onViewDetail,
              child: Text(
                "See details",
                style: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
