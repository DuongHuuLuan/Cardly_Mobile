import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_avatar.dart';
import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:cardly_app/presentation/contact/view/contact_detail/widgets/contact_icon_button.dart';
import 'package:flutter/material.dart';

class ContactDetailHeader extends StatelessWidget {
  final BusinessCardEntity contact;
  final bool isEditing;
  final TextEditingController nameCtrl;
  final TextEditingController titleCtrl;
  final TextEditingController companyCtrl;
  final VoidCallback? onCall;
  final VoidCallback? onEmail;
  final VoidCallback? onLinkedIn;
  final VoidCallback? onWebsite;

  const ContactDetailHeader({
    super.key,
    required this.contact,
    required this.isEditing,
    required this.nameCtrl,
    required this.titleCtrl,
    required this.companyCtrl,
    this.onCall,
    this.onEmail,
    this.onLinkedIn,
    this.onWebsite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppAvatar(name: contact.fullName ?? "", radius: 40),
        const SizedBox(height: 12),
        if (isEditing)
          _buildEdit()
        else ...[
          _buildView(),
          const SizedBox(height: 6),
          ContactIconButton(
            onCall: onCall,
            onEmail: onEmail,
            onLinkedIn: onLinkedIn,
            onWebsite: onWebsite,
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildView() {
    return Column(
      children: [
        Text(contact.fullName ?? 'Unknown', style: AppTextStyles.heading2),
        if (contact.jobTitle != null) ...[
          const SizedBox(height: 4),
          Text(
            contact.jobTitle!,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColor.greyDark),
          ),
        ],
        if (contact.company != null) ...[
          const SizedBox(height: 2),
          Text(
            contact.company!,
            style: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
          ),
        ],
      ],
    );
  }

  Widget _buildEdit() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
      child: Column(children: _editFields()),
    );
  }

  List<Widget> _editFields() {
    return [
      _editField(
        controller: nameCtrl,
        label: "FULL NAME *",
        icon: Icons.person,
        hint: "Enter full name",
      ),
      const Divider(height: 20, thickness: 1, color: AppColor.greyLight),
      _editField(
        controller: titleCtrl,
        label: "JOB TITLE",
        icon: Icons.badge_outlined,
        hint: "Enter job title",
      ),
      const Divider(height: 20, thickness: 1, color: AppColor.greyLight),
      _editField(
        controller: companyCtrl,
        label: "COMPANY",
        icon: Icons.business_outlined,
        hint: "Enter company name",
      ),
      const Divider(height: 20, thickness: 1, color: AppColor.greyLight),
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
