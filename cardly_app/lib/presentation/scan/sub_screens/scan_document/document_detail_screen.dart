import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:cardly_app/domain/usecase/contact/save_contact_usecase.dart';
import 'package:cardly_app/injection_container.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_document/widgets/action_bar.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_document/widgets/document_form_field.dart';
import 'package:flutter/material.dart';

class DocumentDetailScreen extends StatefulWidget {
  final List<ScannedDocument> documents;
  const DocumentDetailScreen({super.key, required this.documents});

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  late final BusinessCardEntity _card;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _titleCtrl;
  late final TextEditingController _companyCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _websiteCtrl;
  late final TextEditingController _linkedinCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _notesCtrl;

  bool _isEnriching = false;

  @override
  void initState() {
    super.initState();
    _card = (widget.documents.first as BusinessCardDocument).card;

    _nameCtrl = TextEditingController(text: _card.fullName ?? '');
    _titleCtrl = TextEditingController(text: _card.jobTitle ?? '');
    _companyCtrl = TextEditingController(text: _card.company ?? '');
    _phoneCtrl = TextEditingController(text: _card.phone ?? '');
    _emailCtrl = TextEditingController(text: _card.email ?? '');
    _websiteCtrl = TextEditingController(text: _card.website ?? '');
    _linkedinCtrl = TextEditingController(text: _card.linkedIn ?? '');
    _addressCtrl = TextEditingController(text: _card.address ?? '');
    _notesCtrl = TextEditingController(text: _card.notes ?? '');
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

  BusinessCardEntity get _updatedCard => _card.copyWith(
    fullName: _nameCtrl.text,
    jobTitle: _titleCtrl.text,
    company: _companyCtrl.text,
    phone: _phoneCtrl.text,
    email: _emailCtrl.text,
    website: _websiteCtrl.text,
    linkedIn: _linkedinCtrl.text,
    address: _addressCtrl.text,
    notes: _notesCtrl.text,
  );

  Future<void> _onEnrich() async {
    setState(() => _isEnriching = true);
    // Simulate AI enrichment
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      if (_titleCtrl.text.isEmpty) _titleCtrl.text = "Sales Director";
      if (_companyCtrl.text.isEmpty) _companyCtrl.text = "ABC Corporation";
      if (_emailCtrl.text.isEmpty) _emailCtrl.text = "d.pham@abccorp.vn";
      if (_websiteCtrl.text.isEmpty) _websiteCtrl.text = "https://abccorp.vn";
      if (_linkedinCtrl.text.isEmpty) {
        _linkedinCtrl.text = "https://linkedin.com/in/phamvand";
      }
      _isEnriching = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Information enriched successfully!"),
        backgroundColor: AppColor.success,
      ),
    );
  }

  Future<void> _onSave() async {
    final card = _updatedCard;
    final result = await getIt<SaveContactUsecase>().call(card);
    if (!mounted) return;

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.message),
          backgroundColor: AppColor.error,
        ),
      ),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Contact saved: ${card.fullName ?? ''}"),
            backgroundColor: AppColor.success,
          ),
        );
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Information", style: AppTextStyles.heading3),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "AI has extracted information from the business card. Please review and edit if necessary.",
              style: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  DocumentFormField(
                    label: "Full Name",
                    controller: _nameCtrl,
                    hintText: "Enter full name",
                    icon: Icons.person_outline,
                  ),
                  DocumentFormField(
                    label: "Job Title",
                    controller: _titleCtrl,
                    hintText: "Enter job title",
                    icon: Icons.badge_outlined,
                  ),
                  DocumentFormField(
                    label: "Company",
                    controller: _companyCtrl,
                    hintText: "Enter company name",
                    icon: Icons.business_outlined,
                  ),
                  DocumentFormField(
                    label: "Phone Number",
                    controller: _phoneCtrl,
                    hintText: "Enter phone number",
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  DocumentFormField(
                    label: "Email",
                    controller: _emailCtrl,
                    hintText: "Enter email address",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  DocumentFormField(
                    label: "Website",
                    controller: _websiteCtrl,
                    hintText: "Enter website URL",
                    icon: Icons.language_outlined,
                    keyboardType: TextInputType.url,
                  ),
                  DocumentFormField(
                    label: "LinkedIn",
                    controller: _linkedinCtrl,
                    hintText: "Enter LinkedIn URL",
                    icon: Icons.link_outlined,
                    keyboardType: TextInputType.url,
                  ),
                  DocumentFormField(
                    label: "Address",
                    controller: _addressCtrl,
                    hintText: "Enter address",
                    icon: Icons.location_on_outlined,
                  ),
                  DocumentFormField(
                    label: "Notes",
                    controller: _notesCtrl,
                    hintText: "Add notes",
                    icon: Icons.notes_outlined,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            ActionBar(
              onEnrich: _onEnrich,
              onSave: _onSave,
              isEnriching: _isEnriching,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
