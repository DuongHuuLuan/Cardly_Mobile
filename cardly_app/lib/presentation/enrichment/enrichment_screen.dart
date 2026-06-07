import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:cardly_app/domain/entities/enrichment/enrichment_entity.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_cubit.dart';
import 'package:cardly_app/presentation/contact/view/contact_detail/contact_detail_screen.dart';
import 'package:cardly_app/presentation/enrichment/cubit/enrichment_cubit.dart';
import 'package:cardly_app/presentation/enrichment/cubit/enrichment_state.dart';
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
    _cubit.enrich(widget.enrichmentData);
  }

  Future<void> _save() async {
    final enriched = _cubit.state.enrichment;
    if (enriched == null) return;

    final updatedCard = BusinessCardEntity(
      id: widget.card.id,
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

  Widget _buildBriefSection(EnrichmentEntity data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.summarize_outlined,
                color: AppColor.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Professional Brief",
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            data.professionalBrief ?? '',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColor.greyDark,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordsSection(EnrichmentEntity data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.label_outline, color: AppColor.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                "Keywords",
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (data.keywords ?? []).map((keyword) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  keyword,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightsSection(EnrichmentEntity data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_outlined,
                color: Colors.amberAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Highlights",
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...(data.highlights ?? []).asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(top: entry.key > 0 ? 8 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColor.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColor.greyDark,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EnrichmentCubit, EnrichmentState>(
      listenWhen: (previous, current) =>
          previous.status == EnrichmentStatus.loading &&
          current.status == EnrichmentStatus.failure,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColor.error,
            ),
          );
        }
      },
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
    );
  }

  Widget _buildBody(EnrichmentState state) {
    switch (state.status) {
      case EnrichmentStatus.loading:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                "Enriching information...",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColor.greyDark,
                ),
              ),
            ],
          ),
        );

      case EnrichmentStatus.loaded:
        final data = state.enrichment!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildBriefSection(data),
              const SizedBox(height: 16),
              _buildKeywordsSection(data),
              const SizedBox(height: 16),
              _buildHighlightsSection(data),
            ],
          ),
        );

      case EnrichmentStatus.failure:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColor.error,
                ),
                const SizedBox(height: 16),
                Text(
                  "Enrichment failed",
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.errorMessage ?? "Please try again",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColor.greyDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                AppElevatedButton(
                  label: "Retry",
                  onPressed: () => _cubit.enrich(widget.enrichmentData),
                  labelStyle: AppTextStyles.bodyLarge.copyWith(
                    color: AppColor.white,
                  ),
                ),
              ],
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
