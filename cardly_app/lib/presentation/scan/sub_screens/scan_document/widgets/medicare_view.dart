import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/domain/Entities/medicare_card.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_document/widgets/info_row.dart';
import 'package:flutter/material.dart';

class MedicareView extends StatelessWidget {
  final MedicareCardEntity data;
  const MedicareView({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Medicare Card', style: AppTextStyles.heading3),
          const Divider(),
          InfoRow(label: 'Card Number', value: data.cardNumber),
          InfoRow(label: 'First Name', value: data.firstName),
          InfoRow(label: 'Middle Name', value: data.middleName),
          InfoRow(label: 'Last Name', value: data.lastName),
          InfoRow(label: 'Expiry Date', value: data.expiryDate),
          InfoRow(label: 'Position', value: data.position),
        ],
      ),
    );
  }
}
