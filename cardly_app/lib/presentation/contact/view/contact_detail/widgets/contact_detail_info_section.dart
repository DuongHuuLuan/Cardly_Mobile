import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_info_tile.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:flutter/material.dart';

class ContactDetailInfoSection extends StatelessWidget {
  final BusinessCardEntity contact;
  final bool isEditing;
  final TextEditingController phoneCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController websiteCtrl;
  final TextEditingController linkedinCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController notesCtrl;

  const ContactDetailInfoSection({
    super.key,
    required this.contact,
    required this.isEditing,
    required this.phoneCtrl,
    required this.emailCtrl,
    required this.websiteCtrl,
    required this.linkedinCtrl,
    required this.addressCtrl,
    required this.notesCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: isEditing ? _editFields() : _viewFields()),
    );
  }

  List<Widget> _viewFields() {
    return [
      const Divider(height: 12, thickness: 1, color: AppColor.white),
      AppInfoTile(
        icon: Icons.phone_outlined,
        label: "Phone",
        value: contact.phone,
      ),
      const Divider(height: 20, thickness: 1, color: AppColor.greyLight),
      AppInfoTile(
        icon: Icons.email_outlined,
        label: "Email",
        value: contact.email,
      ),
      const Divider(height: 20, thickness: 1, color: AppColor.greyLight),
      AppInfoTile(
        icon: Icons.language_outlined,
        label: "Website",
        value: contact.website,
      ),
      const Divider(height: 20, thickness: 1, color: AppColor.greyLight),
      AppInfoTile(
        icon: Icons.link_outlined,
        label: "LinkedIn",
        value: contact.linkedIn,
      ),
      const Divider(height: 20, thickness: 1, color: AppColor.greyLight),
      AppInfoTile(
        icon: Icons.location_on_outlined,
        label: "Address",
        value: contact.address,
      ),
      const Divider(height: 20, thickness: 1, color: AppColor.greyLight),
      AppInfoTile(
        icon: Icons.notes_outlined,
        label: "Notes",
        value: contact.notes,
      ),
    ];
  }

  List<Widget> _editFields() {
    return [
      _editField(
        controller: phoneCtrl,
        label: "PHONE NUMBER",
        icon: Icons.phone_outlined,
        hint: "Enter phone number",
      ),
      const Divider(height: 20, thickness: 1, color: AppColor.greyLight),
      _editField(
        controller: emailCtrl,
        label: "EMAIL",
        icon: Icons.email_outlined,
        hint: "Enter email address",
      ),
      const Divider(height: 20, thickness: 1, color: AppColor.greyLight),
      _editField(
        controller: websiteCtrl,
        label: "WEBSITE",
        icon: Icons.language_outlined,
        hint: "Enter website URL",
      ),
      const Divider(height: 20, thickness: 1, color: AppColor.greyLight),
      _editField(
        controller: linkedinCtrl,
        label: "LINKEDIN",
        icon: Icons.link_outlined,
        hint: "Enter LinkedIn URL",
      ),
      const Divider(height: 20, thickness: 1, color: AppColor.greyLight),
      _editField(
        controller: addressCtrl,
        label: "ADDRESS",
        icon: Icons.location_on_outlined,
        hint: "Enter address",
      ),
      const Divider(height: 20, thickness: 1, color: AppColor.greyLight),
      _editField(
        controller: notesCtrl,
        label: "NOTES",
        icon: Icons.notes_outlined,
        hint: "Add notes",
      ),
    ];
  }

  Widget _editField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColor.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColor.grey),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: controller,
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
