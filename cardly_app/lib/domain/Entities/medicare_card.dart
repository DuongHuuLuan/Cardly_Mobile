import 'package:equatable/equatable.dart';

class MedicareCardEntity extends Equatable {
  final String? cardNumber;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? expiryDate;
  final String? position;

  const MedicareCardEntity({
    this.cardNumber,
    this.firstName,
    this.middleName,
    this.lastName,
    this.expiryDate,
    this.position,
  });

  MedicareCardEntity copyWith({
    String? cardNumber,
    String? firstName,
    String? middleName,
    String? lastName,
    String? expiryDate,
    String? position,
  }) => MedicareCardEntity(
    cardNumber: cardNumber ?? this.cardNumber,
    firstName: firstName ?? this.firstName,
    middleName: middleName ?? this.middleName,
    lastName: lastName ?? this.lastName,
    expiryDate: expiryDate ?? this.expiryDate,
    position: position ?? this.position,
  );

  @override
  List<Object?> get props => [
    cardNumber,
    firstName,
    middleName,
    lastName,
    expiryDate,
    position,
  ];
}
