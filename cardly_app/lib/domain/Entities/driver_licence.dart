import 'package:equatable/equatable.dart';

class DriverLicenceEntity extends Equatable {
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? address;
  final String? licenceNumber;
  final String? state;
  final String? cardNumber;
  final String? licenceClass;
  final String? expiryDate;
  final String? dateOfBirth;

  const DriverLicenceEntity({
    this.firstName,
    this.middleName,
    this.lastName,
    this.address,
    this.licenceNumber,
    this.state,
    this.cardNumber,
    this.licenceClass,
    this.expiryDate,
    this.dateOfBirth,
  });

  DriverLicenceEntity copyWith({
    String? firstName,
    String? middleName,
    String? lastName,
    String? address,
    String? licenceNumber,
    String? state,
    String? cardNumber,
    String? licenceClass,
    String? expiryDate,
    String? dateOfBirth,
  }) => DriverLicenceEntity(
    firstName: firstName ?? this.firstName,
    middleName: middleName ?? this.middleName,
    lastName: lastName ?? this.lastName,
    address: address ?? this.address,
    licenceNumber: licenceNumber ?? this.licenceNumber,
    state: state ?? this.state,
    cardNumber: cardNumber ?? this.cardNumber,
    licenceClass: licenceClass ?? this.licenceClass,
    expiryDate: expiryDate ?? this.expiryDate,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
  );

  @override
  List<Object?> get props => [
    firstName,
    middleName,
    lastName,
    address,
    licenceNumber,
    state,
    cardNumber,
    licenceClass,
    expiryDate,
    dateOfBirth,
  ];
}
