import 'package:cardly_app/domain/Entities/medicare_card.dart';

class MedicareCardMapper {
  static MedicareCardEntity fromMap(Map<String, dynamic> map) =>
      MedicareCardEntity(
        cardNumber: map['medicare_card_number'] as String?,
        firstName: map['medicare_card_first_name'] as String?,
        middleName: map['medicare_card_middle_name'] as String?,
        lastName: map['medicare_card_last_name'] as String?,
        expiryDate: map['medicare_card_expiry_date'] as String?,
        position: map['medicare_card_position'] as String?,
      );
}
