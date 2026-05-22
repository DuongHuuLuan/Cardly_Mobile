import 'package:equatable/equatable.dart';
import 'package:cardly_app/domain/Entities/passport.dart';
import 'package:cardly_app/domain/Entities/driver_licence.dart';
import 'package:cardly_app/domain/Entities/medicare_card.dart';

sealed class ScannedDocument extends Equatable {
  final String id;
  final List<String>? frontImages;
  final List<String>? backImages;

  const ScannedDocument({required this.id, this.frontImages, this.backImages});
}

class PassportDocument extends ScannedDocument {
  final PassportEntity data;

  const PassportDocument({
    required super.id,
    required this.data,
    super.frontImages,
    super.backImages,
  });

  PassportDocument copyWith({
    String? id,
    PassportEntity? data,
    List<String>? frontImages,
    List<String>? backImages,
  }) => PassportDocument(
    id: id ?? this.id,
    data: data ?? this.data,
    frontImages: frontImages ?? this.frontImages,
    backImages: backImages ?? this.backImages,
  );

  @override
  List<Object?> get props => [id, data, frontImages, backImages];
}

class DriverLicenceDocument extends ScannedDocument {
  final DriverLicenceEntity data;

  const DriverLicenceDocument({
    required super.id,
    required this.data,
    super.frontImages,
    super.backImages,
  });

  DriverLicenceDocument copyWith({
    String? id,
    DriverLicenceEntity? data,
    List<String>? frontImages,
    List<String>? backImages,
  }) => DriverLicenceDocument(
    id: id ?? this.id,
    data: data ?? this.data,
    frontImages: frontImages ?? this.frontImages,
    backImages: backImages ?? this.backImages,
  );

  @override
  List<Object?> get props => [id, data, frontImages, backImages];
}

class MedicareDocument extends ScannedDocument {
  final MedicareCardEntity data;

  const MedicareDocument({
    required super.id,
    required this.data,
    super.frontImages,
    super.backImages,
  });

  MedicareDocument copyWith({
    String? id,
    MedicareCardEntity? data,
    List<String>? frontImages,
    List<String>? backImages,
  }) => MedicareDocument(
    id: id ?? this.id,
    data: data ?? this.data,
    frontImages: frontImages ?? this.frontImages,
    backImages: backImages ?? this.backImages,
  );

  @override
  List<Object?> get props => [id, data, frontImages, backImages];
}
