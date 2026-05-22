import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_document/widgets/document_card.dart';
import 'package:flutter/material.dart';

class DocumentDetailScreen extends StatelessWidget {
  final List<ScannedDocument> documents;
  const DocumentDetailScreen({super.key, required this.documents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Document Details", style: AppTextStyles.heading3),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: documents.map((doc) => DocumentCard(document: doc)).toList(),
      ),
    );
  }
}
