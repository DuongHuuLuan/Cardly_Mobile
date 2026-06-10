import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:cardly_app/core/widgets/app_loading_overlay.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_cubit.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_state.dart';
import 'package:cardly_app/presentation/contact/view/contact_detail/contact_detail_screen.dart';
import 'package:cardly_app/presentation/enrichment/cubit/enrichment_cubit.dart';
import 'package:cardly_app/presentation/enrichment/cubit/enrichment_state.dart';
import 'package:cardly_app/presentation/enrichment/widgets/enrichment_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EnrichmentScreen extends StatefulWidget {
  static const routerName = "/enrichment";

  final BusinessCardEntity card;
  final Map<String, dynamic> enrichmentData;

  const EnrichmentScreen({
    super.key,
    required this.card,
    required this.enrichmentData,
  });

  @override
  State<EnrichmentScreen> createState() => _EnrichmentScreenState();
}

class _EnrichmentScreenState extends State<EnrichmentScreen> {
  late final EnrichmentCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<EnrichmentCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.enrich(widget.enrichmentData);
    });
  }

  Future<void> _save() async {
    final enriched = _cubit.state.enrichment;
    if (enriched == null) return;

    final data = widget.enrichmentData;

    final updatedCard = BusinessCardEntity(
      id: widget.card.id,
      processingId: widget.card.processingId ?? widget.card.id,
      fullName: widget.card.fullName,
      jobTitle: widget.card.jobTitle,
      company: widget.card.company,
      phone: widget.card.phone,
      email: widget.card.email,
      website: widget.card.website,
      linkedIn: widget.card.linkedIn,
      facebook: widget.card.facebook,
      address: widget.card.address,
      qrCodeContent: widget.card.qrCodeContent,
      notes: widget.card.notes,
      eventName: widget.card.eventName,
      location: widget.card.location,
      createdAt: widget.card.createdAt,
      brief: enriched.professionalBrief,
      keywords: enriched.keywords,
      highlights: enriched.highlights,
      images: widget.card.images,
    );
    final contactCubit = context.read<ContactCubit>();
    final saved = await contactCubit.save(updatedCard);
    if (saved != null && mounted) {
      context.go(ContactDetailScreen.routerName, extra: saved);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EnrichmentCubit, EnrichmentState>(
          listenWhen: (previous, current) =>
              previous.status != current.status ||
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            if (state.status == EnrichmentStatus.loading) {
              context.showLoading("AI is analyzing...");
            }

            if (state.status == EnrichmentStatus.loaded ||
                state.status == EnrichmentStatus.failure) {
              context.hideLoading();
            }
          },
        ),

        BlocListener<ContactCubit, ContactState>(
          listenWhen: (previous, current) =>
              previous.status != current.status ||
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            if (state.status == ContactStatus.saving) {
              context.showLoading("Saving contact...");
            }

            if (state.status == ContactStatus.loaded ||
                state.status == ContactStatus.failure) {
              context.hideLoading();
            }

            if (state.status == ContactStatus.failure &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
        ),
      ],
      child: BlocBuilder<EnrichmentCubit, EnrichmentState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppAppBar(
              title: "Enrich Information",
              leadingType: AppBarLeading.close,
              onLeadingPressed: () => context.pop(),
            ),
            body: _buildBody(state),
            bottomNavigationBar: state.status == EnrichmentStatus.loaded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: AppElevatedButton(
                      label: "Save Contact",
                      onPressed: _save,
                      labelStyle: AppTextStyles.bodyLarge.copyWith(
                        color: AppColor.white,
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildBody(EnrichmentState state) {
    switch (state.status) {
      case EnrichmentStatus.loading:
        return const SizedBox.shrink();

      case EnrichmentStatus.loaded:
        final data = state.enrichment!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              EnrichmentBriefSection(data: data),
              const SizedBox(height: 16),
              EnrichmentKeywordsSection(data: data),
              const SizedBox(height: 16),
              EnrichmentHighlightsSection(data: data),
            ],
          ),
        );

      case EnrichmentStatus.failure:
        return EnrichmentFailureView(
          errorMessage: state.errorMessage,
          onRetry: () => _cubit.enrich(widget.enrichmentData),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
