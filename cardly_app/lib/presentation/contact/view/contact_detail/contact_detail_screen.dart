import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_cubit.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_state.dart';
import 'package:cardly_app/presentation/contact/view/contact_detail/widgets/contact_detail_actions.dart';
import 'package:cardly_app/presentation/contact/view/contact_detail/widgets/contact_detail_header.dart';
import 'package:cardly_app/presentation/contact/view/contact_detail/widgets/contact_detail_image_gallery.dart';
import 'package:cardly_app/presentation/contact/view/contact_detail/widgets/contact_detail_info_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ContactDetailScreen extends StatefulWidget {
  static const routerName = "/contact-detail";

  final BusinessCardEntity contact;

  const ContactDetailScreen({super.key, required this.contact});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  bool _isEditing = false;

  late BusinessCardEntity _contact;

  late TextEditingController _nameCtrl;
  late TextEditingController _titleCtrl;
  late TextEditingController _companyCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _websiteCtrl;
  late TextEditingController _linkedinCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
    _initControllers();
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

  void _initControllers() {
    final c = _contact;
    _nameCtrl = TextEditingController(text: c.fullName ?? '');
    _titleCtrl = TextEditingController(text: c.jobTitle ?? '');
    _companyCtrl = TextEditingController(text: c.company ?? '');
    _phoneCtrl = TextEditingController(text: c.phone ?? '');
    _emailCtrl = TextEditingController(text: c.email ?? '');
    _websiteCtrl = TextEditingController(text: c.website ?? '');
    _linkedinCtrl = TextEditingController(text: c.linkedIn ?? '');
    _addressCtrl = TextEditingController(text: c.address ?? '');
    _notesCtrl = TextEditingController(text: c.notes ?? '');
  }

  void _toggleEdit() {
    if (_isEditing) {
      _initControllers();
    }
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _save() {
    final updated = _contact.copyWith(
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
    context.read<ContactCubit>().save(updated);
    setState(() {
      _contact = updated;
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSaving =
        context.watch<ContactCubit>().state.status == ContactStatus.saving;
    return Scaffold(
      appBar: AppAppBar(
        title: _isEditing ? "Edit Contact" : "Contact Detail",
        showBorder: true,
        onLeadingPressed: () {
          if (context.canPop()) {
            context.pop(context);
          }
          context.goToHome();
        },
        actions: [
          IconButton(
            onPressed: _toggleEdit,
            icon: _isEditing
                ? const Icon(Icons.close, size: 26)
                : const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: BlocConsumer<ContactCubit, ContactState>(
        listener: (context, state) {
          if (state.status == ContactStatus.loaded &&
              !state.contacts.any(
                (element) => element.id == widget.contact.id,
              )) {
            context.goToContact();
          } else if (state.status == ContactStatus.failure &&
              state.errorMessage != null) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Error"),
                content: Text(state.errorMessage!),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          final isDeleting = state.status == ContactStatus.deleting;

          return Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: <Widget>[
                  ContactDetailImageGallery(images: _contact.images),
                  ContactDetailHeader(
                    contact: _contact,
                    isEditing: _isEditing,
                    nameCtrl: _nameCtrl,
                    titleCtrl: _titleCtrl,
                    companyCtrl: _companyCtrl,
                  ),
                  ContactDetailInfoSection(
                    contact: _contact,
                    isEditing: _isEditing,
                    phoneCtrl: _phoneCtrl,
                    emailCtrl: _emailCtrl,
                    websiteCtrl: _websiteCtrl,
                    linkedinCtrl: _linkedinCtrl,
                    addressCtrl: _addressCtrl,
                    notesCtrl: _notesCtrl,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: ContactDetailActions(
              isEditing: _isEditing,
              isSaving: isSaving,
              isDeleting: isDeleting,
              onSave: _save,
              onDelete: () =>
                  context.read<ContactCubit>().delete(_contact.id!),
            ),
          );
        },
      ),
    );
  }
}
