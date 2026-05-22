import 'package:cardly_app/domain/Entities/driver_licence.dart';

class DriverLicenceMapper {
  static DriverLicenceEntity fromMap(Map<String, dynamic> map) =>
      DriverLicenceEntity(
        firstName: map['australian_driver_license_first_name'] as String?,
        middleName: map['australian_driver_license_middle_name'] as String?,
        lastName: map['australian_driver_license_last_name'] as String?,
        address: map['australian_driver_license_address'] as String?,
        licenceNumber:
            map['australian_driver_license_licence_number'] as String?,
        state: map['australian_driver_license_state'] as String?,
        cardNumber: map['australian_driver_license_card_number'] as String?,
        licenceClass: map['australian_driver_license_class'] as String?,
        expiryDate: map['australian_driver_license_expiry_date'] as String?,
        dateOfBirth: map['australian_driver_license_dob'] as String?,
      );
}
