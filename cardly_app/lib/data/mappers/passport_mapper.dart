import 'package:cardly_app/domain/Entities/passport.dart';

class PassportMapper {
  static PassportEntity fromMap(Map<String, dynamic> map) => PassportEntity(
    firstName: map['australian_passport_first_name'] as String?,
    middleName: map['australian_passport_middle_name'] as String?,
    lastName: map['australian_passport_last_name'] as String?,
    passportNumber: map['australian_passport_number'] as String?,
    dateOfBirth: map['australian_passport_date_of_birth'] as String?,
    dateOfIssue: map['australian_passport_date_of_issue'] as String?,
    expiryDate: map['australian_passport_expiry_date'] as String?,
    nationality: map['australian_passport_nationality'] as String?,
    gender: map['australian_passport_gender'] as String?,
    placeOfBirth: map['australian_passport_place_of_birth'] as String?,
  );
}
