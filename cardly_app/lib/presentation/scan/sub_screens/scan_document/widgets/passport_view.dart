import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/domain/Entities/passport.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_document/widgets/info_row.dart';
import 'package:flutter/material.dart';

class PassportView extends StatelessWidget {
  final PassportEntity data;

  const PassportView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Passport", style: AppTextStyles.heading3),
          const Divider(),
          InfoRow(label: 'First Name', value: data.firstName),
          InfoRow(label: 'Middle Name', value: data.middleName),
          InfoRow(label: 'Last Name', value: data.lastName),
          InfoRow(label: 'Passport Number', value: data.passportNumber),
          InfoRow(label: 'Date of Birth', value: data.dateOfBirth),
          InfoRow(label: 'Date of Issue', value: data.dateOfIssue),
          InfoRow(label: 'Expiry Date', value: data.expiryDate),
          InfoRow(label: 'Nationality', value: data.nationality),
          InfoRow(label: 'Gender', value: data.gender),
          InfoRow(label: 'Place of Birth', value: data.placeOfBirth),
        ],
      ),
    );
  }
}
