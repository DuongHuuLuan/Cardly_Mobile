import 'package:equatable/equatable.dart';
import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:cardly_app/domain/enums/document_type.dart';

enum ScanStatus {
  initial,
  imageSelected,
  validating,
  validationFailed,
  uploading,
  success,
  failure,
}

enum ImageSourceType { camera, gallery }

class ScanState extends Equatable {
  final ScanStatus status;
  final DocumentType? documentType;
  final List<String> imagePaths;
  final ImageSourceType? imageSource;
  final List<ScannedDocument> scannedDocuments;
  final double uploadProgress;
  final List<String> validationErrors;
  final String? errorMessage;

  const ScanState({
    this.status = ScanStatus.initial,
    this.documentType,
    this.imagePaths = const [],
    this.imageSource,
    this.scannedDocuments = const [],
    this.uploadProgress = 0.0,
    this.validationErrors = const [],
    this.errorMessage,
  });

  ScanState copyWith({
    ScanStatus? status,
    DocumentType? documentType,
    List<String>? imagePaths,
    ImageSourceType? imageSource,
    List<ScannedDocument>? scannedDocuments,
    double? uploadProgress,
    List<String>? validationErrors,
    String? errorMessage,
  }) => ScanState(
    status: status ?? this.status,
    documentType: documentType ?? this.documentType,
    imagePaths: imagePaths ?? this.imagePaths,
    imageSource: imageSource ?? this.imageSource,
    scannedDocuments: scannedDocuments ?? this.scannedDocuments,
    uploadProgress: uploadProgress ?? this.uploadProgress,
    validationErrors: validationErrors ?? this.validationErrors,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [
    status,
    documentType,
    imagePaths,
    imageSource,
    scannedDocuments,
    uploadProgress,
    validationErrors,
    errorMessage,
  ];
}
