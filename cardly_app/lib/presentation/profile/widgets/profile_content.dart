import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:cardly_app/core/widgets/app_info_tile.dart';
import 'package:cardly_app/domain/entities/user_entity.dart';
import 'package:cardly_app/presentation/profile/widgets/user_section.dart';
import 'package:flutter/material.dart';

class ProfileContent extends StatelessWidget {
  final UserEntity? user;
  final VoidCallback? onEdit;
  final VoidCallback? onNotifications;
  final VoidCallback? onPrivacy;
  final VoidCallback? onHelp;
  final VoidCallback? onLogout;
  final bool isLoading;
  const ProfileContent({
    super.key,
    this.user,
    this.onEdit,
    this.onNotifications,
    this.onPrivacy,
    this.onHelp,
    this.onLogout,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          UserSection(user: user, onEdit: onEdit),
          const SizedBox(height: 10),
          //menu
          Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AppInfoTile(
                  icon: Icons.notifications_none,
                  label: "Notifications",
                  onTap: onNotifications,
                  labelStyle: AppTextStyles.bodySmall,
                  iconSize: 22,
                  trailingIcon: Icons.arrow_forward_ios,
                  trailingIconSize: 18,
                ),
                const Divider(height: 1),
                const SizedBox(height: 16),
                AppInfoTile(
                  icon: Icons.lock_outline,
                  label: "Privacy",
                  onTap: onPrivacy,
                  labelStyle: AppTextStyles.bodySmall,
                  iconSize: 22,
                  trailingIcon: Icons.arrow_forward_ios,
                  trailingIconSize: 18,
                ),
                const Divider(height: 1),
                const SizedBox(height: 16),
                AppInfoTile(
                  icon: Icons.help_outline,
                  label: "Help",
                  onTap: onHelp,
                  labelStyle: AppTextStyles.bodySmall,
                  iconSize: 22,
                  trailingIcon: Icons.arrow_forward_ios,
                  trailingIconSize: 18,
                ),
              ],
            ),
          ),
          AppElevatedButton(
            label: "Log out",
            labelColor: AppColor.error,
            iconAfterText: false,
            icon: Icon(Icons.logout, color: AppColor.error, size: 26),
            onPressed: onLogout,
            borderColor: AppColor.error.withValues(alpha: 0.4),
            backgroundColor: AppColor.white,
            isLoading: isLoading,
          ).paddingAll(20),
        ],
      ),
    );
  }
}
