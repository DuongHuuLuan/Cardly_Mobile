import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_document/widgets/driver_licence_view.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_document/widgets/medicare_view.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_document/widgets/passport_view.dart';
import 'package:flutter/material.dart';

class DocumentCard extends StatelessWidget {
  final ScannedDocument document;
  const DocumentCard({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: switch (document) {
        PassportDocument doc => PassportView(data: doc.data),
        DriverLicenceDocument doc => DriverLicenceView(data: doc.data),
        MedicareDocument doc => MedicareView(data: doc.data),
      },
    );
  }
}
