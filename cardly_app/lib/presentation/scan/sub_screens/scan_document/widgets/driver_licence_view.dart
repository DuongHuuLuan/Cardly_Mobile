import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/domain/Entities/driver_licence.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_document/widgets/info_row.dart';
import 'package:flutter/material.dart';

class DriverLicenceView extends StatelessWidget {
  final DriverLicenceEntity data;
  const DriverLicenceView({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Driver Licence', style: AppTextStyles.heading3),
          const Divider(),
          InfoRow(label: 'First Name', value: data.firstName),
          InfoRow(label: 'Middle Name', value: data.middleName),
          InfoRow(label: 'Last Name', value: data.lastName),
          InfoRow(label: 'Address', value: data.address),
          InfoRow(label: 'Licence Number', value: data.licenceNumber),
          InfoRow(label: 'State', value: data.state),
          InfoRow(label: 'Card Number', value: data.cardNumber),
          InfoRow(label: 'Class', value: data.licenceClass),
          InfoRow(label: 'Expiry Date', value: data.expiryDate),
          InfoRow(label: 'Date of Birth', value: data.dateOfBirth),
        ],
      ),
    );
  }
}
