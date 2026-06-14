import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/core/widgets/app_loading_overlay.dart';
import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_cubit.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_state.dart';
import 'package:cardly_app/presentation/contact/view/contact_detail/widgets/contact_detail_actions.dart';
import 'package:cardly_app/presentation/contact/view/contact_detail/widgets/contact_detail_enrichment_section.dart';
import 'package:cardly_app/presentation/contact/view/contact_detail/widgets/contact_detail_header.dart';
import 'package:cardly_app/presentation/contact/view/contact_detail/widgets/contact_detail_image_gallery.dart';
import 'package:cardly_app/presentation/contact/view/contact_detail/widgets/contact_detail_info_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailScreen extends StatefulWidget {
  static const routerName = "/contact-detail/:id";

  final String contactId;

  const ContactDetailScreen({super.key, required this.contactId});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  bool _isEditing = false;
  BusinessCardEntity? _contact;

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
    debugPrint('Current Contact Detail ID: ${widget.contactId}');
    debugPrint(
      'Suggested Deep Link: cardly:///contact-detail/${widget.contactId}',
    );
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
    final c = _contact!;

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

  void _resetControllers() {
    final c = _contact!;

    _nameCtrl.text = c.fullName ?? '';
    _titleCtrl.text = c.jobTitle ?? '';
    _companyCtrl.text = c.company ?? '';
    _phoneCtrl.text = c.phone ?? '';
    _emailCtrl.text = c.email ?? '';
    _websiteCtrl.text = c.website ?? '';
    _linkedinCtrl.text = c.linkedIn ?? '';
    _addressCtrl.text = c.address ?? '';
    _notesCtrl.text = c.notes ?? '';
  }

  void _toggleEdit() {
    if (_isEditing) {
      _resetControllers();
    }

    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _openUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    var uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      uri = Uri.tryParse('https://$url');
    }
    if (uri != null) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {}
    }
  }

  Future<void> _save() async {
    final contact = _contact;
    if (contact == null) return;

    final updated = contact.copyWith(
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

    final saved = await context.read<ContactCubit>().save(updated);

    if (!mounted) return;

    if (saved != null) {
      setState(() {
        _contact = saved;
        _isEditing = false;
      });
    }
  }

  Future<void> _delete() async {
    final contact = _contact;
    if (contact == null) return;

    await context.read<ContactCubit>().delete(contact);
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.goToHome();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactCubit, ContactState>(
      listenWhen: (previous, current) =>
          previous.contacts != current.contacts ||
          previous.status != current.status,
      listener: (context, state) {
        if (state.status == ContactStatus.loading ||
            state.status == ContactStatus.saving ||
            state.status == ContactStatus.deleting) {
          context.showLoading(
            state.status == ContactStatus.saving
                ? "Saving contact..."
                : state.status == ContactStatus.deleting
                ? "Deleting contact..."
                : "Loading contact...",
          );
        }

        if (state.status == ContactStatus.loaded ||
            state.status == ContactStatus.failure) {
          context.hideLoading();
        }

        if (state.contacts.isEmpty) return;
        final contact = state.contacts.firstWhere(
          (c) => c.id == widget.contactId,
          orElse: () => _contact!,
        );
        if (contact != _contact) {
          setState(() {
            _contact = contact;
            _initControllers();
          });
        }
      },
      builder: (context, state) {
        if (state.status == ContactStatus.loading || _contact == null) {
          return const Scaffold(body: SizedBox());
        }

        final contact = _contact!;
        return Scaffold(
          appBar: AppAppBar(
            title: _isEditing ? "Edit Contact" : "Contact Detail",
            showBorder: true,
            onLeadingPressed: _handleBack,
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
            listenWhen: (previous, current) {
              return previous.status != current.status ||
                  previous.errorMessage != current.errorMessage;
            },
            listener: (context, state) {
              if (state.status == ContactStatus.loaded &&
                  !state.contacts.any((element) => element.id == contact.id)) {
                context.goToContact();
              }

              if (state.status == ContactStatus.failure &&
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
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: <Widget>[
                    ContactDetailImageGallery(images: contact.images),

                    ContactDetailHeader(
                      contact: contact,
                      isEditing: _isEditing,
                      nameCtrl: _nameCtrl,
                      titleCtrl: _titleCtrl,
                      companyCtrl: _companyCtrl,
                      onCall: () => _openUrl('tel:${contact.phone}'),
                      onEmail: () => _openUrl('mailto:${contact.email}'),
                      onLinkedIn: contact.linkedIn != null
                          ? () => _openUrl(contact.linkedIn)
                          : null,
                      onWebsite: contact.website != null
                          ? () => _openUrl(contact.website)
                          : null,
                    ),

                    ContactDetailInfoSection(
                      contact: contact,
                      isEditing: _isEditing,
                      phoneCtrl: _phoneCtrl,
                      emailCtrl: _emailCtrl,
                      websiteCtrl: _websiteCtrl,
                      linkedinCtrl: _linkedinCtrl,
                      addressCtrl: _addressCtrl,
                      notesCtrl: _notesCtrl,
                    ),

                    ContactDetailEnrichmentSection(contact: contact),
                  ],
                ),
              );
            },
          ),

          bottomNavigationBar: BlocBuilder<ContactCubit, ContactState>(
            builder: (context, state) {
              return ContactDetailActions(
                isEditing: _isEditing,
                onSave: _save,
                onDelete: _delete,
              );
            },
          ),
        );
      },
    );
  }
}
