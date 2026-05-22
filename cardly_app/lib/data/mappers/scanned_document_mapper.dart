import 'package:cardly_app/data/models/scan_response_model.dart';
import 'package:cardly_app/domain/Entities/driver_licence.dart';
import 'package:cardly_app/domain/Entities/medicare_card.dart';
import 'package:cardly_app/domain/Entities/passport.dart';
import 'package:cardly_app/domain/Entities/scanned_document.dart';

class ScannedDocumentMapper {
  static ScannedDocument fromResponse(ScanResponseModel response) {
    final data = response.data;
    switch (response.type) {
      case 'passport':
        return PassportDocument(
          id: response.id,
          data: PassportEntity(
            firstName: data['australian_passport_first_name'] as String?,
            middleName: data['australian_passport_middle_name'] as String?,
            lastName: data['australian_passport_last_name'] as String?,
            passportNumber: data['australian_passport_number'] as String?,
            dateOfBirth: data['australian_passport_date_of_birth'] as String?,
            dateOfIssue: data['australian_passport_date_of_issue'] as String?,
            expiryDate: data['australian_passport_expiry_date'] as String?,
            nationality: data['australian_passport_nationality'] as String?,
            gender: data['australian_passport_gender'] as String?,
            placeOfBirth: data['australian_passport_place_of_birth'] as String?,
          ),
          frontImages: response.frontImages,
          backImages: response.backImages,
        );
      case 'driverLicence':
        return DriverLicenceDocument(
          id: response.id,
          data: DriverLicenceEntity(
            firstName: data['australian_driver_license_first_name'] as String?,
            middleName:
                data['australian_driver_license_middle_name'] as String?,
            lastName: data['australian_driver_license_last_name'] as String?,
            address: data['australian_driver_license_address'] as String?,
            licenceNumber:
                data['australian_driver_license_licence_number'] as String?,
            state: data['australian_driver_license_state'] as String?,
            cardNumber:
                data['australian_driver_license_card_number'] as String?,
            licenceClass: data['australian_driver_license_class'] as String?,
            expiryDate:
                data['australian_driver_license_expiry_date'] as String?,
            dateOfBirth: data['australian_driver_license_dob'] as String?,
          ),
          frontImages: response.frontImages,
          backImages: response.backImages,
        );
      case 'medicareCard':
        return MedicareDocument(
          id: response.id,
          data: MedicareCardEntity(
            cardNumber: data['medicare_card_number'] as String?,
            firstName: data['medicare_card_first_name'] as String?,
            middleName: data['medicare_card_middle_name'] as String?,
            lastName: data['medicare_card_last_name'] as String?,
            expiryDate: data['medicare_card_expiry_date'] as String?,
            position: data['medicare_card_position'] as String?,
          ),
          frontImages: response.frontImages,
          backImages: response.backImages,
        );
      default:
        throw ArgumentError('Unknown document type: ${response.type}');
    }
  }
}
