import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_text_form_field.dart';
import 'package:cardly_app/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

class EditProfileContent extends StatefulWidget {
  final UserEntity? user;

  const EditProfileContent({super.key, this.user});

  @override
  State<EditProfileContent> createState() => EditProfileContentState();
}

class EditProfileContentState extends State<EditProfileContent> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameCtrl;
  late final TextEditingController positionCtrl;
  late final TextEditingController companyCtrl;
  late final TextEditingController phoneCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController websiteCtrl;
  late final TextEditingController linkedinCtrl;
  late final TextEditingController addressCtrl;
  late final TextEditingController bioCtrl;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    nameCtrl = TextEditingController(text: user?.name ?? '');
    positionCtrl = TextEditingController(text: user?.position ?? '');
    companyCtrl = TextEditingController(text: user?.company ?? '');
    phoneCtrl = TextEditingController(text: user?.phone ?? '');
    emailCtrl = TextEditingController(text: user?.email ?? '');
    websiteCtrl = TextEditingController(text: user?.website ?? '');
    linkedinCtrl = TextEditingController(text: user?.linkedIn ?? '');
    addressCtrl = TextEditingController(text: user?.address ?? '');
    bioCtrl = TextEditingController(text: user?.bio ?? '');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    positionCtrl.dispose();
    companyCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    websiteCtrl.dispose();
    linkedinCtrl.dispose();
    addressCtrl.dispose();
    bioCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EditProfileContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.user != oldWidget.user) {
      nameCtrl.text = widget.user?.name ?? '';
      positionCtrl.text = widget.user?.position ?? '';
      companyCtrl.text = widget.user?.company ?? '';
      phoneCtrl.text = widget.user?.phone ?? '';
      emailCtrl.text = widget.user?.email ?? '';
      websiteCtrl.text = widget.user?.website ?? '';
      linkedinCtrl.text = widget.user?.linkedIn ?? '';
      addressCtrl.text = widget.user?.address ?? '';
      bioCtrl.text = widget.user?.bio ?? '';
    }
  }

  UserEntity buildUpdatedUser(UserEntity original) {
    return original.copyWith(
      name: nameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      position: positionCtrl.text.trim(),
      company: companyCtrl.text.trim(),
      address: addressCtrl.text.trim(),
      website: websiteCtrl.text.trim(),
      linkedIn: linkedinCtrl.text.trim(),
      bio: bioCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            AppTextFormField(
              controller: nameCtrl,
              labelText: "Name",
              hintText: "Enter name",
              prefixIcon: Icons.person_outline,
              groupLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.black70,
                fontWeight: FontWeight.w500,
              ),
              showAsGroup: true,
              groupBackground: AppColor.white,
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              controller: emailCtrl,
              labelText: "Email",
              hintText: "Enter email",
              prefixIcon: Icons.email_outlined,
              groupLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.black70,
                fontWeight: FontWeight.w500,
              ),
              showAsGroup: true,
              groupBackground: AppColor.white,
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              controller: phoneCtrl,
              labelText: "Phone",
              hintText: "Enter phone",
              prefixIcon: Icons.phone_outlined,
              groupLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.black70,
                fontWeight: FontWeight.w500,
              ),
              showAsGroup: true,
              groupBackground: AppColor.white,
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              controller: positionCtrl,
              labelText: "Position",
              hintText: "Enter position",
              prefixIcon: Icons.work_outline,
              groupLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.black70,
                fontWeight: FontWeight.w500,
              ),
              showAsGroup: true,
              groupBackground: AppColor.white,
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              controller: companyCtrl,
              labelText: "Company",
              hintText: "Enter company",
              prefixIcon: Icons.business,
              groupLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.black70,
                fontWeight: FontWeight.w500,
              ),
              showAsGroup: true,
              groupBackground: AppColor.white,
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              controller: addressCtrl,
              labelText: "Address",
              hintText: "Enter address",
              prefixIcon: Icons.location_on_outlined,
              groupLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.black70,
                fontWeight: FontWeight.w500,
              ),
              showAsGroup: true,
              groupBackground: AppColor.white,
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              controller: websiteCtrl,
              labelText: "Website",
              hintText: "Enter website",
              prefixIcon: Icons.language,
              groupLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.black70,
                fontWeight: FontWeight.w500,
              ),
              showAsGroup: true,
              groupBackground: AppColor.white,
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              controller: linkedinCtrl,
              labelText: "LinkedIn",
              hintText: "Enter LinkedIn URL",
              prefixIcon: Icons.link,
              groupLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.black70,
                fontWeight: FontWeight.w500,
              ),
              showAsGroup: true,
              groupBackground: AppColor.white,
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              controller: bioCtrl,
              labelText: "Bio",
              hintText: "Enter bio",
              prefixIcon: Icons.description,
              groupLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.black70,
                fontWeight: FontWeight.w500,
              ),
              showAsGroup: true,
              groupBackground: AppColor.white,
            ),
          ],
        ),
      ),
    );
  }
}
