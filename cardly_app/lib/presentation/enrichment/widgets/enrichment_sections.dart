import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/domain/entities/enrichment/enrichment_entity.dart';

class EnrichmentBriefSection extends StatelessWidget {
  final EnrichmentEntity data;

  const EnrichmentBriefSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
}

// Keywords
class EnrichmentKeywordsSection extends StatelessWidget {
  final EnrichmentEntity data;

  const EnrichmentKeywordsSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
}

// Highlights
class EnrichmentHighlightsSection extends StatelessWidget {
  final EnrichmentEntity data;

  const EnrichmentHighlightsSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
              const Icon(
                Icons.auto_awesome_outlined,
                color: AppColor.secondary,
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
}

// State Loading View
class EnrichmentLoadingView extends StatelessWidget {
  const EnrichmentLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            "Enriching information...",
            style: AppTextStyles.bodyMedium.copyWith(color: AppColor.greyDark),
          ),
        ],
      ),
    );
  }
}

// State Failure View
class EnrichmentFailureView extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onRetry;

  const EnrichmentFailureView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColor.error),
            const SizedBox(height: 16),
            Text(
              "Enrichment failed",
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? "Please try again",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.greyDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppElevatedButton(
              label: "Retry",
              onPressed: onRetry,
              labelStyle: AppTextStyles.bodyLarge.copyWith(
                color: AppColor.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
