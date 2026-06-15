import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/utils/permission_utils.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailScreen extends StatefulWidget {
  static const routerName = "/contact-detail/:id";
  final String contactId;
  const ContactDetailScreen({super.key, required this.contactId});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  late ContactCubit contactCubit;
  final _nameCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _linkedinCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    contactCubit = context.read<ContactCubit>();
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

  void _initControllers(BusinessCardEntity contact) {
    _nameCtrl.text = contact.fullName ?? '';
    _titleCtrl.text = contact.jobTitle ?? '';
    _companyCtrl.text = contact.company ?? '';
    _phoneCtrl.text = contact.phone ?? '';
    _emailCtrl.text = contact.email ?? '';
    _websiteCtrl.text = contact.website ?? '';
    _linkedinCtrl.text = contact.linkedIn ?? '';
    _addressCtrl.text = contact.address ?? '';
    _notesCtrl.text = contact.notes ?? '';
  }

  Future<void> _pickAvatar() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from the library'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    if (source == ImageSource.gallery) {
      final granted = await requestGalleryPermission(context);
      if (!granted || !mounted) return;
    }
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, maxWidth: 512);
    if (picked != null) {
      contactCubit.updateDraftAvatar(picked.path);
    }
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
    final saved = await contactCubit.saveSelectedContact(
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
    if (saved != null && mounted) {
      _initControllers(saved);
    }
  }

  Future<void> _delete() async {
    await contactCubit.deleteSelectedContact();
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
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage ||
          previous.selectedContact?.id != current.selectedContact?.id ||
          previous.contacts.length != current.contacts.length,
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

        if (state.status == ContactStatus.loaded &&
            state.selectedContact == null &&
            state.contacts.isEmpty) {
          context.goToContact();
        }
      },
      builder: (context, state) {
        final contact = state.selectedContact;
        if (contact != null && !_controllersInitialized) {
          _controllersInitialized = true;
          _initControllers(contact);
        }
        if (state.status == ContactStatus.loading || contact == null) {
          return const Scaffold(body: SizedBox());
        }
        return Scaffold(
          appBar: AppAppBar(
            title: state.isEditing ? "Edit Contact" : "Contact Detail",
            showBorder: true,
            onLeadingPressed: _handleBack,
            actions: [
              IconButton(
                onPressed: () => contactCubit.toggleEdit(),
                icon: state.isEditing
                    ? const Icon(Icons.close, size: 26)
                    : const Icon(Icons.edit_outlined),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: <Widget>[
                ContactDetailImageGallery(images: contact.images),
                ContactDetailHeader(
                  contact: contact,
                  isEditing: state.isEditing,
                  nameCtrl: _nameCtrl,
                  titleCtrl: _titleCtrl,
                  companyCtrl: _companyCtrl,
                  onAvatarTap: _pickAvatar,
                  avatar: state.avatar,
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
                  isEditing: state.isEditing,
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
          ),

          bottomNavigationBar: BlocBuilder<ContactCubit, ContactState>(
            builder: (context, state) {
              return ContactDetailActions(
                isEditing: state.isEditing,
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
