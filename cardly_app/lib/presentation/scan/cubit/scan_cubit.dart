import 'dart:io';

import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cardly_app/domain/enums/document_type.dart';
import 'package:cardly_app/domain/usecase/card/scan_card_usecase.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class ScanCubit extends Cubit<ScanState> {
  final ScanCardUsecase scanCardUsecase;
  final ImagePicker _picker = ImagePicker();

  ScanCubit({required this.scanCardUsecase}) : super(const ScanState());

  static const int _maxImages = 2;

  Future<void> pickFromCamera() async {
    emit(
      state.copyWith(
        status: ScanStatus.imageSelected,
        imageSource: ImageSourceType.camera,
      ),
    );
  }

  Future<void> pickFromGallery() async {
    final existing = state.imagePaths;
    if (existing.length >= _maxImages) {
      emit(
        state.copyWith(
          status: ScanStatus.validationFailed,
          errorMessage: "Maximum $_maxImages images allowed",
        ),
      );
      return;
    }
    List<XFile> files;
    try {
      final result = await _picker.pickMultiImage();
      files = result;
    } catch (e) {
      emit(
        state.copyWith(
          status: ScanStatus.validationFailed,
          errorMessage: 'Failed to pick images',
        ),
      );
      return;
    }
    if (files.isEmpty) return;
    final paths = <String>[];
    for (final f in files) {
      if (existing.length + paths.length >= _maxImages) {
        emit(
          state.copyWith(
            status: ScanStatus.validationFailed,
            errorMessage: "Maximum $_maxImages images allowed",
          ),
        );
        return;
      }
      if (!f.name.endsWith('.jpg') &&
          !f.name.endsWith('.jpeg') &&
          !f.name.endsWith('.png')) {
        emit(
          state.copyWith(
            status: ScanStatus.validationFailed,
            errorMessage: 'Only JPG and PNG files are supported',
          ),
        );
        return;
      }
      final localPath = await _saveToTemp(f);
      final file = File(localPath);
      if (file.lengthSync() > 10 * 1024 * 1024) {
        emit(
          state.copyWith(
            status: ScanStatus.validationFailed,
            errorMessage: 'Image must be less than 10MB',
          ),
        );
        return;
      }
      paths.add(localPath);
    }
    emit(
      state.copyWith(
        status: ScanStatus.imageSelected,
        imagePaths: [...existing, ...paths],
        imageSource: ImageSourceType.gallery,
      ),
    );
  }

  void confirmEdit(String path) {
    final existing = state.imagePaths;

    if (existing.length >= _maxImages) {
      emit(
        state.copyWith(
          status: ScanStatus.validationFailed,
          errorMessage: "Maximum $_maxImages images allowed",
        ),
      );
      return;
    }
    final newPaths = existing.contains(path) ? existing : [...existing, path];
    emit(
      state.copyWith(status: ScanStatus.imageSelected, imagePaths: newPaths),
    );
  }

  void removeImage(int index) {
    final newPaths = [...state.imagePaths]..removeAt(index);
    emit(
      state.copyWith(
        status: newPaths.isEmpty
            ? ScanStatus.initial
            : ScanStatus.imageSelected,
        imagePaths: newPaths,
      ),
    );
  }

  Future<void> retake() async {
    emit(const ScanState());
    await pickFromCamera();
  }

  bool validate() {
    for (final path in state.imagePaths) {
      final file = File(path);
      if (!file.path.endsWith('.jpg') &&
          !file.path.endsWith('.jpeg') &&
          !file.path.endsWith('.png')) {
        emit(
          state.copyWith(
            status: ScanStatus.validationFailed,
            errorMessage: 'Only JPG and PNG files are supported',
          ),
        );
        return false;
      }
      if (file.lengthSync() > 10 * 1024 * 1024) {
        emit(
          state.copyWith(
            status: ScanStatus.validationFailed,
            errorMessage: 'Image must be less than 10MB',
          ),
        );
        return false;
      }
    }
    return true;
  }

  Future<void> uploadAndScan() async {
    if (!validate()) return;
    final docType = state.documentType;
    if (docType == null) {
      emit(
        state.copyWith(
          status: ScanStatus.validationFailed,
          errorMessage: 'Document type not selected',
        ),
      );
      return;
    }
    emit(state.copyWith(status: ScanStatus.uploading, uploadProgress: 0.0));
    try {
      await _simulateProgress();
      final result = await scanCardUsecase(docType, state.imagePaths);
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: ScanStatus.failure,
            errorMessage: failure.message,
          ),
        ),
        (docs) => emit(
          state.copyWith(
            status: ScanStatus.success,
            scannedDocuments: docs,
            uploadProgress: 1.0,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ScanStatus.failure, errorMessage: 'Error: $e'),
      );
    }
  }

  void updateDocument(int index, ScannedDocument updatedDoc) {
    final docs = [...state.scannedDocuments];
    docs[index] = updatedDoc;
    emit(state.copyWith(scannedDocuments: docs));
  }

  Future<void> _simulateProgress() async {
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (!isClosed) emit(state.copyWith(uploadProgress: i / 10));
    }
  }

  Future<String> _saveToTemp(XFile file) async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File(path).writeAsBytes(await file.readAsBytes());
    return path;
  }

  void setDocumentType(DocumentType type) =>
      emit(state.copyWith(documentType: type));

  void reset() => emit(const ScanState());
}
