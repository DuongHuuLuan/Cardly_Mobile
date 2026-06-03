import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/string_ext.dart';
import 'package:cardly_app/core/widgets/app_text_form_field.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  final BusinessCardEntity? initialData;
  const ContactForm({super.key, this.initialData});

  @override
  ContactFormState createState() => ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _titleCtrl;
  late final TextEditingController _companyCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _websiteCtrl;
  late final TextEditingController _linkedinCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    _nameCtrl = TextEditingController(text: d?.fullName ?? '');
    _titleCtrl = TextEditingController(text: d?.jobTitle ?? '');
    _companyCtrl = TextEditingController(text: d?.company ?? '');
    _phoneCtrl = TextEditingController(text: d?.phone ?? '');
    _emailCtrl = TextEditingController(text: d?.email ?? '');
    _websiteCtrl = TextEditingController(text: d?.website ?? '');
    _linkedinCtrl = TextEditingController(text: d?.linkedIn ?? '');
    _addressCtrl = TextEditingController(text: d?.address ?? '');
    _notesCtrl = TextEditingController(text: d?.notes ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _titleCtrl.dispose();
    _companyCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _websiteCtrl.dispose();
    _linkedinCtrl.dispose();
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  bool validate() => _formKey.currentState?.validate() ?? false;

  BusinessCardEntity get data => BusinessCardEntity(
    fullName: _nameCtrl.text.trim(),
    jobTitle: _titleCtrl.text.trim(),
    company: _companyCtrl.text.trim(),
    phone: _phoneCtrl.text.trim(),
    email: _emailCtrl.text.trim(),
    website: _websiteCtrl.text.trim(),
    linkedIn: _linkedinCtrl.text.trim(),
    address: _addressCtrl.text.trim(),
    notes: _notesCtrl.text.trim(),
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // color: AppColor.white,
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: 0.04),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            AppTextFormField(
              controller: _nameCtrl,
              labelText: "FULL NAME *",
              hintText: "Enter full name",
              groupLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.black70,
                fontWeight: FontWeight.w500,
              ),
              showAsGroup: true,
              groupBackground: AppColor.white,
              validator: (v) =>
                  v.isNullOrTrimEmpty ? "Full name is required" : null,
            ),
            const SizedBox(height: 6),
            AppTextFormField(
              controller: _titleCtrl,
              labelText: "JOB TITLE",
              hintText: "Enter job title",
              groupLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.black70,
                fontWeight: FontWeight.w500,
              ),
              showAsGroup: true,
              groupBackground: AppColor.white,
            ),
            const SizedBox(height: 6),
            AppTextFormField(
              controller: _companyCtrl,
              labelText: "COMPANY",
              hintText: "Enter company name",
              groupLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.black70,
                fontWeight: FontWeight.w500,
              ),
              showAsGroup: true,
              groupBackground: AppColor.white,
            ),
            const SizedBox(height: 6),
            AppTextFormField(
              controller: _phoneCtrl,
              labelText: "PHONE NUMBER",
              hintText: "Enter phone number",
              groupLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.black70,
                fontWeight: FontWeight.w500,
              ),
              showAsGroup: true,
              groupBackground: AppColor.white,
            ),
            const SizedBox(height: 6),
            AppTextFormField(
              controller: _emailCtrl,
              labelText: "EMAIL",
              hintText: "Enter email address",
              groupLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.black70,
                fontWeight: FontWeight.w500,
              ),
              showAsGroup: true,
              groupBackground: AppColor.white,
            ),
            const SizedBox(height: 6),
            AppTextFormField(
              controller: _websiteCtrl,
              labelText: "WEBSITE",
              hintText: "Enter website URL",
              groupLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.black70,
                fontWeight: FontWeight.w500,
              ),
              showAsGroup: true,
              groupBackground: AppColor.white,
            ),
            const SizedBox(height: 6),
            AppTextFormField(
              controller: _linkedinCtrl,
              labelText: "LINKEDIN",
              hintText: "Enter LinkedIn URL",
              groupLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.black70,
                fontWeight: FontWeight.w500,
              ),
              showAsGroup: true,
              groupBackground: AppColor.white,
            ),
            const SizedBox(height: 6),
            AppTextFormField(
              controller: _addressCtrl,
              labelText: "ADDRESS",
              hintText: "Enter address",
              groupLabelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.black70,
                fontWeight: FontWeight.w500,
              ),
              showAsGroup: true,
              groupBackground: AppColor.white,
            ),
            const SizedBox(height: 6),
            AppTextFormField(
              controller: _notesCtrl,
              labelText: "NOTES",
              hintText: "Add notes",
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
