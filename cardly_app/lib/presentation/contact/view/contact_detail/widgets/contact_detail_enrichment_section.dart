import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:flutter/material.dart';

class ContactDetailEnrichmentSection extends StatelessWidget {
  final BusinessCardEntity contact;

  const ContactDetailEnrichmentSection({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final hasBrief = contact.brief != null && contact.brief!.isNotEmpty;
    final hasKeywords =
        contact.keywords != null && contact.keywords!.isNotEmpty;
    final hasHighlights =
        contact.highlights != null && contact.highlights!.isNotEmpty;

    if (!hasBrief && !hasKeywords && !hasHighlights) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_outlined,
                color: AppColor.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "AI Enrichment",
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (hasBrief) _buildBrief(),
          if (hasKeywords) ...[const SizedBox(height: 8), _buildKeywords()],
          if (hasHighlights) ...[const SizedBox(height: 8), _buildHighlights()],
        ],
      ),
    );
  }

  Widget _buildBrief() {
    return Container(
      width: double.infinity,
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
          Text(
            "Professional Brief",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColor.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            contact.brief!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColor.greyDark,

              height: 1.5,
            ),
          ),
        ],
      ).paddingAll(20),
    );
  }

  Widget _buildKeywords() {
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
          Text(
            "Keywords",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColor.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: contact.keywords!.map((k) {
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
                  k,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlights() {
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
          Text(
            "Highlights",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColor.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...contact.highlights!.asMap().entries.map((entry) {
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
                      style: AppTextStyles.bodySmall.copyWith(
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
