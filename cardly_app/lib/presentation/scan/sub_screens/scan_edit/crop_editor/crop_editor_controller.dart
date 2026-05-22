import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'utils/image_processor.dart';

enum CropEditorMode { crop, perspective }

enum AspectRatioOption {
  custom('Custom'),
  original('Original'),
  fullVertical('Full V'),
  fullHorizontal('Full H'),
  square('1:1'),
  ratio16_9('16:9'),
  ratio4_3('4:3');

  final String label;
  const AspectRatioOption(this.label);
}

class _EditorSnapshot {
  final Rect cropRect;
  final List<Offset> quadCorners;
  final CropEditorMode mode;
  final double rotationDegrees;
  final AspectRatioOption selectedRatio;

  _EditorSnapshot({
    required this.cropRect,
    required this.quadCorners,
    required this.mode,
    required this.rotationDegrees,
    required this.selectedRatio,
  });
}

class CropEditorController extends ChangeNotifier {
  String? _imagePath;
  Size _imageSize = Size.zero;

  CropEditorMode _mode = CropEditorMode.crop;
  Rect _cropRect = const Rect.fromLTWH(0.05, 0.05, 0.9, 0.9);
  List<Offset> _quadCorners = [];
  double _rotationDegrees = 0;
  AspectRatioOption _selectedRatio = AspectRatioOption.custom;

  final List<_EditorSnapshot> _undoStack = [];
  final List<_EditorSnapshot> _redoStack = [];

  String? get imagePath => _imagePath;
  Size get imageSize => _imageSize;
  CropEditorMode get mode => _mode;
  Rect get cropRect => _cropRect;
  List<Offset> get quadCorners => _quadCorners;
  double get rotationDegrees => _rotationDegrees;
  AspectRatioOption get selectedRatio => _selectedRatio;
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  void initFromFile(String path) {
    _imagePath = path;
    final bytes = File(path).readAsBytesSync();
    final image = img.decodeImage(bytes);
    if (image != null) {
      _imageSize = Size(image.width.toDouble(), image.height.toDouble());
      final m = 0.1;
      _quadCorners = [
        Offset(m, m),
        Offset(1 - m, m),
        Offset(1 - m, 1 - m),
        Offset(m, 1 - m),
      ];
    }
    notifyListeners();
  }

  void _saveSnapshot() {
    _undoStack.add(
      _EditorSnapshot(
        cropRect: _cropRect,
        quadCorners: List.from(_quadCorners),
        mode: _mode,
        rotationDegrees: _rotationDegrees,
        selectedRatio: _selectedRatio,
      ),
    );
    _redoStack.clear();
  }

  void setMode(CropEditorMode mode) {
    if (_mode == mode) return;
    _saveSnapshot();
    _mode = mode;
    notifyListeners();
  }

  void setCropRect(Rect rect) {
    _cropRect = rect;
    notifyListeners();
  }

  void setQuadCorners(List<Offset> corners) {
    _quadCorners = List.from(corners);
    notifyListeners();
  }

  void setRotation(double degrees) {
    _rotationDegrees = degrees;
    notifyListeners();
  }

  void setAspectRatio(AspectRatioOption option) {
    _saveSnapshot();
    _selectedRatio = option;
    if (option != AspectRatioOption.custom) {
      _constrainCropToRatio(option);
    }
    notifyListeners();
  }

  void _constrainCropToRatio(AspectRatioOption option) {
    double targetRatio;
    switch (option) {
      case AspectRatioOption.original:
        targetRatio = _imageSize.width / _imageSize.height;
      case AspectRatioOption.fullVertical:
        targetRatio = 9.0 / 16.0;
      case AspectRatioOption.fullHorizontal:
        targetRatio = 16.0 / 9.0;
      case AspectRatioOption.square:
        targetRatio = 1.0;
      case AspectRatioOption.ratio16_9:
        targetRatio = 16.0 / 9.0;
      case AspectRatioOption.ratio4_3:
        targetRatio = 4.0 / 3.0;
      default:
        return;
    }

    final currentAspect = _cropRect.width / _cropRect.height;
    if (currentAspect > targetRatio) {
      final newWidth = _cropRect.height * targetRatio;
      final dx = (_cropRect.width - newWidth) / 2;
      _cropRect = Rect.fromLTWH(
        _cropRect.left + dx,
        _cropRect.top,
        newWidth,
        _cropRect.height,
      );
    } else {
      final newHeight = _cropRect.width / targetRatio;
      final dy = (_cropRect.height - newHeight) / 2;
      _cropRect = Rect.fromLTWH(
        _cropRect.left,
        _cropRect.top + dy,
        _cropRect.width,
        newHeight,
      );
    }

    _cropRect = Rect.fromLTWH(
      _cropRect.left.clamp(0, 1 - _cropRect.width),
      _cropRect.top.clamp(0, 1 - _cropRect.height),
      _cropRect.width.clamp(0, 1),
      _cropRect.height.clamp(0, 1),
    );
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    _redoStack.add(
      _EditorSnapshot(
        cropRect: _cropRect,
        quadCorners: List.from(_quadCorners),
        mode: _mode,
        rotationDegrees: _rotationDegrees,
        selectedRatio: _selectedRatio,
      ),
    );
    _restore(_undoStack.removeLast());
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    _undoStack.add(
      _EditorSnapshot(
        cropRect: _cropRect,
        quadCorners: List.from(_quadCorners),
        mode: _mode,
        rotationDegrees: _rotationDegrees,
        selectedRatio: _selectedRatio,
      ),
    );
    _restore(_redoStack.removeLast());
  }

  void _restore(_EditorSnapshot snapshot) {
    _cropRect = snapshot.cropRect;
    _quadCorners = List.from(snapshot.quadCorners);
    _mode = snapshot.mode;
    _rotationDegrees = snapshot.rotationDegrees;
    _selectedRatio = snapshot.selectedRatio;
    notifyListeners();
  }

  void reset() {
    _saveSnapshot();
    _cropRect = const Rect.fromLTWH(0.05, 0.05, 0.9, 0.9);
    final m = 0.1;
    _quadCorners = [
      Offset(m, m),
      Offset(1 - m, m),
      Offset(1 - m, 1 - m),
      Offset(m, 1 - m),
    ];
    _rotationDegrees = 0;
    _selectedRatio = AspectRatioOption.custom;
    notifyListeners();
  }

  Future<String> processImage() async {
    if (_imagePath == null) throw Exception('No image loaded');

    final outputPath = _imagePath!;

    await ImageProcessor.process(
      inputPath: _imagePath!,
      outputPath: outputPath,
      rotationDegrees: _rotationDegrees,
      cropRect: _cropRect,
      usePerspective: _mode == CropEditorMode.perspective,
      quadCorners: _quadCorners,
    );

    return outputPath;
  }
}
