import 'dart:ui';

import 'package:equatable/equatable.dart';

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

class CropEditorState extends Equatable {
  final CropEditorMode mode;
  final Rect cropRect;
  final List<Offset> quadCorners;
  final double rotationDegrees;
  final AspectRatioOption selectedRatio;
  final Size imageSize;
  final bool canUndo;
  final bool canRedo;
  final bool isProcessing;

  const CropEditorState({
    this.mode = CropEditorMode.crop,
    this.cropRect = const Rect.fromLTWH(0, 0, 1, 1),
    this.quadCorners = const [],
    this.rotationDegrees = 0,
    this.selectedRatio = AspectRatioOption.custom,
    this.imageSize = Size.zero,
    this.canUndo = false,
    this.canRedo = false,
    this.isProcessing = false,
  });

  CropEditorState copyWith({
    CropEditorMode? mode,
    Rect? cropRect,
    List<Offset>? quadCorners,
    double? rotationDegrees,
    AspectRatioOption? selectedRatio,
    Size? imageSize,
    bool? canUndo,
    bool? canRedo,
    bool? isProcessing,
  }) {
    return CropEditorState(
      mode: mode ?? this.mode,
      cropRect: cropRect ?? this.cropRect,
      quadCorners: quadCorners ?? this.quadCorners,
      rotationDegrees: rotationDegrees ?? this.rotationDegrees,
      selectedRatio: selectedRatio ?? this.selectedRatio,
      imageSize: imageSize ?? this.imageSize,
      canUndo: canUndo ?? this.canUndo,
      canRedo: canRedo ?? this.canRedo,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }

  @override
  List<Object?> get props => [
    mode,
    cropRect,
    quadCorners,
    rotationDegrees,
    selectedRatio,
    imageSize,
    canRedo,
    canUndo,
    isProcessing,
  ];
}
