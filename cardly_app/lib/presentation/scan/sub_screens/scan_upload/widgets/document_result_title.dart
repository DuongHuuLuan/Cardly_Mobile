import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/domain/entities/scanned_document.dart';
import 'package:flutter/material.dart';

class DocumentResultTile extends StatelessWidget {
  final ScannedDocument document;
  const DocumentResultTile({required this.document});

  @override
  Widget build(BuildContext context) {
    final d = document as BusinessCardDocument;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColor.primary.withValues(alpha: 0.07),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.badge_outlined, color: AppColor.black87),
        ),
        title: Text(
          d.card.fullName ?? 'Unknown',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColor.black87),
        ),
        subtitle: Text(
          d.card.company ?? d.card.jobTitle ?? 'Business Card',
          style: AppTextStyles.bodySmall.copyWith(color: AppColor.greyDark),
        ),
      ),
    );
  }
}
