import 'dart:io';
import 'package:cardly_app/presentation/scan/sub_screens/scan_edit/crop_editor/utils/image_processor.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'crop_editor_state.dart';

class CropEditorCubit extends Cubit<CropEditorState> {
  final String imagePath;
  final List<_EditorSnapshot> _undoStack = [];
  final List<_EditorSnapshot> _redoStack = [];

  CropEditorCubit(this.imagePath) : super(const CropEditorState()) {
    _loadImage();
  }

  void _loadImage() {
    final bytes = File(imagePath).readAsBytesSync();
    final image = img.decodeImage(bytes);
    if (image == null) return;

    final size = Size(image.width.toDouble(), image.height.toDouble());
    final m = 0.1;
    final corners = [
      Offset(m, m),
      Offset(1 - m, m),
      Offset(1 - m, 1 - m),
      Offset(m, 1 - m),
    ];

    emit(state.copyWith(imageSize: size, quadCorners: corners));
  }

  //snapshot
  void _saveSnapshot() {
    _undoStack.add(
      _EditorSnapshot(
        cropRect: state.cropRect,
        quadCorners: List.from(state.quadCorners),
        mode: state.mode,
        rotation: state.rotationDegrees,
        ratio: state.selectedRatio,
      ),
    );
    _redoStack.clear();
    emit(state.copyWith(canUndo: true, canRedo: false));
  }

  // setMode
  void setMode(CropEditorMode mode) {
    if (state.mode == mode) return;
    _saveSnapshot();
    emit(state.copyWith(mode: mode));
  }

  // Crop rect
  void setCropRect(Rect rect) {
    emit(state.copyWith(cropRect: rect));
  }

  // Quad corners
  void setQuadCorners(List<Offset> corners) {
    emit(state.copyWith(quadCorners: corners));
  }

  // ROTATION
  void setRotation(double degrees) {
    emit(state.copyWith(rotationDegrees: degrees));
  }

  // ASPECT RATIO
  void setAspectRatio(AspectRatioOption option) {
    _saveSnapshot();
    final newRect = option == AspectRatioOption.custom
        ? state.cropRect
        : _constrainToRatio(option);
    emit(state.copyWith(selectedRatio: option, cropRect: newRect));
  }

  Rect _constrainToRatio(AspectRatioOption option) {
    final targetRatio = switch (option) {
      AspectRatioOption.original =>
        state.imageSize.width / state.imageSize.height,
      AspectRatioOption.fullVertical => 9 / 16,
      AspectRatioOption.fullHorizontal => 16 / 9,
      AspectRatioOption.square => 1.0,
      AspectRatioOption.ratio16_9 => 16 / 9,
      AspectRatioOption.ratio4_3 => 4 / 3,
      _ => 1.0,
    };
    final r = state.cropRect;
    final current = r.width / r.height;
    if (current > targetRatio) {
      final w = r.height * targetRatio;
      return Rect.fromLTWH(r.left + (r.width - w) / 2, r.top, w, r.height);
    } else {
      final h = r.width / targetRatio;
      return Rect.fromLTWH(r.left, r.top + (r.height - h) / 2, r.width, h);
    }
  }

  //  UNDO / REDO
  void undo() {
    if (_undoStack.isEmpty) return;
    _redoStack.add(
      _EditorSnapshot(
        cropRect: state.cropRect,
        quadCorners: List.from(state.quadCorners),
        mode: state.mode,
        rotation: state.rotationDegrees,
        ratio: state.selectedRatio,
      ),
    );
    _restore(_undoStack.removeLast());
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    _undoStack.add(
      _EditorSnapshot(
        cropRect: state.cropRect,
        quadCorners: List.from(state.quadCorners),
        mode: state.mode,
        rotation: state.rotationDegrees,
        ratio: state.selectedRatio,
      ),
    );
    _restore(_redoStack.removeLast());
  }

  void _restore(_EditorSnapshot s) {
    emit(
      state.copyWith(
        cropRect: s.cropRect,
        quadCorners: s.quadCorners,
        mode: s.mode,
        rotationDegrees: s.rotation,
        selectedRatio: s.ratio,
        canUndo: _undoStack.isNotEmpty,
        canRedo: _redoStack.isNotEmpty,
      ),
    );
  }

  void reset() {
    _saveSnapshot();
    emit(
      state.copyWith(
        cropRect: const Rect.fromLTWH(0, 0, 1, 1),
        quadCorners: [Offset(0, 0), Offset(1, 0), Offset(1, 1), Offset(0, 1)],
        rotationDegrees: 0,
        selectedRatio: AspectRatioOption.custom,
      ),
    );
  }

  // PROCESS
  Future<String> processImage({String? outputPath}) async {
    emit(state.copyWith(isProcessing: true));
    try {
      final out =
          outputPath ??
          '${(await getTemporaryDirectory()).path}/edit_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await ImageProcessor.process(
        inputPath: imagePath,
        outputPath: out,
        rotationDegrees: state.rotationDegrees,
        cropRect: state.cropRect,
        usePerspective: state.mode == CropEditorMode.perspective,
        quadCorners: state.quadCorners,
      );
      emit(state.copyWith(isProcessing: false));
      return out;
    } catch (e) {
      emit(state.copyWith(isProcessing: false));
      rethrow;
    }
  }
}

class _EditorSnapshot {
  final Rect cropRect;
  final List<Offset> quadCorners;
  final CropEditorMode mode;
  final double rotation;
  final AspectRatioOption ratio;
  _EditorSnapshot({
    required this.cropRect,
    required this.quadCorners,
    required this.mode,
    required this.rotation,
    required this.ratio,
  });
}
