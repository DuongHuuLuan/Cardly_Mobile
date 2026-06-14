import 'package:equatable/equatable.dart';
import 'package:cardly_app/domain/entities/scanned_document.dart';

enum ScanStatus {
  initial,
  imageSelected,
  validating,
  validationFailed,
  uploading,
  processing,
  success,
  failure,
}

enum ImageSourceType { camera, gallery }

class ScanState extends Equatable {
  final ScanStatus status;
  final List<String> imagePaths;
  final bool isProcessing;
  final ImageSourceType? imageSource;
  final List<ScannedDocument> scannedDocuments;
  final double uploadProgress;
  final List<String> validationErrors;
  final String? errorMessage;

  const ScanState({
    this.status = ScanStatus.initial,
    this.imagePaths = const [],
    this.imageSource,
    this.scannedDocuments = const [],
    this.uploadProgress = 0.0,
    this.validationErrors = const [],
    this.errorMessage,
    this.isProcessing = false,
  });

  ScanState copyWith({
    ScanStatus? status,
    List<String>? imagePaths,
    ImageSourceType? imageSource,
    List<ScannedDocument>? scannedDocuments,
    double? uploadProgress,
    List<String>? validationErrors,
    String? errorMessage,
    bool? isProcessing,
  }) => ScanState(
    status: status ?? this.status,
    imagePaths: imagePaths ?? this.imagePaths,
    imageSource: imageSource ?? this.imageSource,
    scannedDocuments: scannedDocuments ?? this.scannedDocuments,
    uploadProgress: uploadProgress ?? this.uploadProgress,
    validationErrors: validationErrors ?? this.validationErrors,
    errorMessage: errorMessage ?? this.errorMessage,
    isProcessing: isProcessing ?? this.isProcessing,
  );

  @override
  List<Object?> get props => [
    status,
    imagePaths,
    imageSource,
    scannedDocuments,
    uploadProgress,
    validationErrors,
    errorMessage,
  ];
}
