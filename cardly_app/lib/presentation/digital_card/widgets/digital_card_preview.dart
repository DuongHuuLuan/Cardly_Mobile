import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_avatar.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';
import 'package:flutter/material.dart';

class DigitalCardPreview extends StatelessWidget {
  final String? name;
  final String? position;
  final String? company;
  final String? avatar;
  const DigitalCardPreview({
    super.key,
    this.name,
    this.position,
    this.company,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.primary,
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppAvatar(
            name: name![0],
            imageUrl: avatar,
            radius: 30,
            backgroundColor: AppColor.grey,
          ),
          const SizedBox(height: 24),
          Text(
            name!,
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
          const SizedBox(height: 10),
          Text(
            "Add a short bio about yourself...",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColor.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
