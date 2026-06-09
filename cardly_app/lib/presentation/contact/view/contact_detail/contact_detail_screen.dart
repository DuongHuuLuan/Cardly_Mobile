import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/core/widgets/app_avatar.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:cardly_app/core/widgets/app_info_tile.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:cardly_app/presentation/contact/view/contact_detail/widgets/contact_icon_button.dart';
import 'package:cardly_app/presentation/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ContactDetailNavigation on BuildContext {
  void goToContactDetail(BusinessCardEntity contact) =>
      go('/contact-detail', extra: contact);
}

class ContactDetailScreen extends StatelessWidget {
  final BusinessCardEntity contact;
  final VoidCallback? onDelete;

  const ContactDetailScreen({super.key, required this.contact, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: "Contact Detail",
        showBorder: true,
        onLeadingPressed: () {
          if (context.canPop()) {
            context.pop(context);
          }
          context.goToHome();
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          children: [
            AppAvatar(name: contact.fullName ?? "", radius: 40),
            const SizedBox(height: 12),
            Text(contact.fullName ?? 'Unknown', style: AppTextStyles.heading2),
            if (contact.jobTitle != null) ...[
              const SizedBox(height: 4),
              Text(
                contact.jobTitle!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColor.greyDark,
                ),
              ),
            ],
            if (contact.company != null) ...[
              const SizedBox(height: 2),
              Text(
                contact.company!,
                style: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
              ),
            ],
            const SizedBox(height: 16),
            ContactIconButton(),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  AppInfoTile(
                    icon: Icons.phone_outlined,
                    label: "Phone",
                    value: contact.phone,
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    color: AppColor.greyLight,
                  ),
                  AppInfoTile(
                    icon: Icons.email_outlined,
                    label: "Email",
                    value: contact.email,
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    color: AppColor.greyLight,
                  ),
                  AppInfoTile(
                    icon: Icons.language_outlined,
                    label: "Website",
                    value: contact.website,
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    color: AppColor.greyLight,
                  ),
                  AppInfoTile(
                    icon: Icons.link_outlined,
                    label: "LinkedIn",
                    value: contact.linkedIn,
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    color: AppColor.greyLight,
                  ),
                  AppInfoTile(
                    icon: Icons.location_on_outlined,
                    label: "Address",
                    value: contact.address,
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    color: AppColor.greyLight,
                  ),
                  AppInfoTile(
                    icon: Icons.notes_outlined,
                    label: "Notes",
                    value: contact.notes,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: AppElevatedButton(
                label: "Delete contact",
                onPressed: onDelete,
                backgroundColor: AppColor.background,
                borderColor: AppColor.error.withValues(alpha: 0.5),
                labelColor: AppColor.error,
                iconAfterText: false,
                icon: Icon(
                  Icons.delete_outline,
                  color: AppColor.error,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
