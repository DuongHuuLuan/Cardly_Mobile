import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_avatar.dart';
import 'package:cardly_app/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

class UserSection extends StatelessWidget {
  final UserEntity? user;
  final VoidCallback? onEdit;
  const UserSection({super.key, this.user, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColor.white),
      child: Row(
        children: [
          AppAvatar(name: user?.name ?? '', imageUrl: user?.avatar, radius: 28),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user?.name ?? 'User',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (user?.position != null || user?.company != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    [
                      user?.position,
                      user?.company,
                    ].whereType<String>().join(" · "),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColor.greyDark,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 12),

          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
        ],
      ),
    );
  }
}
