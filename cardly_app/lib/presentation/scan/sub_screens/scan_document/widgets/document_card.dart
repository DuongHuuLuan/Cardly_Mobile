import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:flutter/material.dart';

class DocumentCard extends StatelessWidget {
  final ScannedDocument document;
  const DocumentCard({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final card = (document as BusinessCardDocument).card;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row('Name', card.fullName),
          _row('Job Title', card.jobTitle),
          _row('Company', card.company),
          _row('Phone', card.phone),
          _row('Email', card.email),
          _row('Website', card.website),
          _row('LinkedIn', card.linkedIn),
          _row('Address', card.address),
        ],
      ).paddingAll(16),
    );
  }

  Widget _row(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColor.black87),
          ),
        ),
      ],
    ).paddingVertical(4);
  }
}
