import 'package:equatable/equatable.dart';

class PassportEntity extends Equatable {
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? passportNumber;
  final String? dateOfBirth;
  final String? dateOfIssue;
  final String? expiryDate;
  final String? nationality;
  final String? gender;
  final String? placeOfBirth;

  const PassportEntity({
    this.firstName,
    this.middleName,
    this.lastName,
    this.passportNumber,
    this.dateOfBirth,
    this.dateOfIssue,
    this.expiryDate,
    this.nationality,
    this.gender,
    this.placeOfBirth,
  });

  PassportEntity copyWith({
    String? firstName,
    String? middleName,
    String? lastName,
    String? passportNumber,
    String? dateOfBirth,
    String? dateOfIssue,
    String? expiryDate,
    String? nationality,
    String? gender,
    String? placeOfBirth,
  }) => PassportEntity(
    firstName: firstName ?? this.firstName,
    middleName: middleName ?? this.middleName,
    lastName: lastName ?? this.lastName,
    passportNumber: passportNumber ?? this.passportNumber,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    dateOfIssue: dateOfIssue ?? this.dateOfIssue,
    expiryDate: expiryDate ?? this.expiryDate,
    nationality: nationality ?? this.nationality,
    gender: gender ?? this.gender,
    placeOfBirth: placeOfBirth ?? this.placeOfBirth,
  );

  @override
  List<Object?> get props => [
    firstName,
    middleName,
    lastName,
    passportNumber,
    dateOfBirth,
    dateOfIssue,
    expiryDate,
    nationality,
    gender,
    placeOfBirth,
  ];
}
