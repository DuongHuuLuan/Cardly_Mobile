import 'dart:io';
import 'dart:math';
import 'package:cardly_app/presentation/scan/crop_editor/crop_editor_cubit.dart';
import 'package:cardly_app/presentation/scan/crop_editor/crop_editor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'corner_handle.dart';
import 'overlay_painters.dart';

class ImageViewport extends StatefulWidget {
  final CropEditorCubit cubit;

  const ImageViewport({super.key, required this.cubit});

  @override
  State<ImageViewport> createState() => _ImageViewportState();
}

class _ImageViewportState extends State<ImageViewport> {
  int _activeHandle = -1;
  Offset _dragStartNorm = Offset.zero;
  List<Offset> _quadAtStart = [];
  Rect _rectAtStart = Rect.zero;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CropEditorCubit, CropEditorState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final displaySize = Size(
              constraints.maxWidth,
              constraints.maxHeight,
            );
            final imageSize = state.imageSize;

            if (imageSize == Size.zero) return const SizedBox();

            final containerRatio = displaySize.width / displaySize.height;
            final imageRatio = imageSize.width / imageSize.height;

            double imgW, imgH;
            if (imageRatio > containerRatio) {
              imgW = displaySize.width;
              imgH = displaySize.width / imageRatio;
            } else {
              imgH = displaySize.height;
              imgW = displaySize.height * imageRatio;
            }

            final offsetX = (displaySize.width - imgW) / 2;
            final offsetY = (displaySize.height - imgH) / 2;

            Offset normToScreen(Offset p) =>
                Offset(offsetX + p.dx * imgW, offsetY + p.dy * imgH);

            return Stack(
              children: [
                Positioned(
                  left: offsetX,
                  top: offsetY,
                  width: imgW,
                  height: imgH,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Transform.rotate(
                      angle: state.rotationDegrees * pi / 180,
                      child: Image.file(
                        File(
                          state.imageSize == Size.zero
                              ? ''
                              : widget.cubit.imagePath,
                        ),
                        fit: BoxFit.contain,
                        width: imgW,
                        height: imgH,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: _buildOverlay(
                    state,
                    displaySize,
                    imgW,
                    imgH,
                    offsetX,
                    offsetY,
                  ),
                ),
                if (state.mode == CropEditorMode.crop)
                  ..._buildCropHandles(state, normToScreen)
                else
                  ..._buildQuadHandles(state, normToScreen),
              ],
            );
          },
        );
      },
    );
  }

  Offset _screenToNorm(
    Offset p,
    double imgW,
    double imgH,
    double offsetX,
    double offsetY,
  ) => Offset(
    ((p.dx - offsetX) / imgW).clamp(0, 1),
    ((p.dy - offsetY) / imgH).clamp(0, 1),
  );

  Widget _buildOverlay(
    CropEditorState state,
    Size displaySize,
    double imgW,
    double imgH,
    double offsetX,
    double offsetY,
  ) {
    if (state.mode == CropEditorMode.crop) {
      final imageRect = Rect.fromLTWH(offsetX, offsetY, imgW, imgH);

      final c = state.cropRect;
      final screenCrop = Rect.fromLTWH(
        offsetX + c.left * imgW,
        offsetY + c.top * imgH,
        c.width * imgW,
        c.height * imgH,
      );

      return GestureDetector(
        onPanStart: (d) =>
            _onCropPanStart(d, screenCrop, imgW, imgH, offsetX, offsetY),
        onPanUpdate: (d) =>
            _onCropPanUpdate(d, screenCrop, imgW, imgH, offsetX, offsetY),
        onPanEnd: (_) => _activeHandle = -1,
        child: CustomPaint(
          painter: CropOverlayPainter(
            cropRect: screenCrop,
            imageRect: imageRect,
          ),
        ),
      );
    } else {
      return GestureDetector(
        onPanStart: (d) => _onQuadPanStart(d, imgW, imgH, offsetX, offsetY),
        onPanUpdate: (d) => _onQuadPanUpdate(d, imgW, imgH, offsetX, offsetY),
        onPanEnd: (_) => _activeHandle = -1,
        child: CustomPaint(
          painter: PerspectiveOverlayPainter(
            corners: state.quadCorners
                .map(
                  (c) => Offset(offsetX + c.dx * imgW, offsetY + c.dy * imgH),
                )
                .toList(),
          ),
        ),
      );
    }
  }

  void _onCropPanStart(
    DragStartDetails d,
    Rect screenCrop,
    double imgW,
    double imgH,
    double ox,
    double oy,
  ) {
    final pos = _screenToNorm(d.localPosition, imgW, imgH, ox, oy);
    _activeHandle = _hitTestCrop(pos, widget.cubit.state.cropRect);
    _dragStartNorm = pos;
    _rectAtStart = widget.cubit.state.cropRect;
  }

  void _onCropPanUpdate(
    DragUpdateDetails d,
    Rect screenCrop,
    double imgW,
    double imgH,
    double ox,
    double oy,
  ) {
    if (_activeHandle == -1) return;
    final pos = _screenToNorm(d.localPosition, imgW, imgH, ox, oy);
    final delta = pos - _dragStartNorm;
    final r = _rectAtStart;

    const minSize = 0.08;
    Rect newRect;

    switch (_activeHandle) {
      case 0:
        newRect = Rect.fromLTRB(
          (r.left + delta.dx).clamp(0, r.right - minSize),
          (r.top + delta.dy).clamp(0, r.bottom - minSize),
          r.right,
          r.bottom,
        );
      case 1:
        newRect = Rect.fromLTRB(
          r.left,
          (r.top + delta.dy).clamp(0, r.bottom - minSize),
          (r.right + delta.dx).clamp(r.left + minSize, 1),
          r.bottom,
        );
      case 2:
        newRect = Rect.fromLTRB(
          (r.left + delta.dx).clamp(0, r.right - minSize),
          r.top,
          r.right,
          (r.bottom + delta.dy).clamp(r.top + minSize, 1),
        );
      case 3:
        newRect = Rect.fromLTRB(
          r.left,
          r.top,
          (r.right + delta.dx).clamp(r.left + minSize, 1),
          (r.bottom + delta.dy).clamp(r.top + minSize, 1),
        );
      case 4:
        double l = r.left + delta.dx;
        double t = r.top + delta.dy;
        if (l < 0) l = 0;
        if (t < 0) t = 0;
        if (l + r.width > 1) l = 1 - r.width;
        if (t + r.height > 1) t = 1 - r.height;
        newRect = Rect.fromLTWH(l, t, r.width, r.height);
      default:
        return;
    }

    widget.cubit.setCropRect(newRect);
  }

  void _onQuadPanStart(
    DragStartDetails d,
    double imgW,
    double imgH,
    double ox,
    double oy,
  ) {
    final pos = _screenToNorm(d.localPosition, imgW, imgH, ox, oy);
    _activeHandle = _hitTestQuad(pos, widget.cubit.state.quadCorners);
    _dragStartNorm = pos;
    _quadAtStart = List.from(widget.cubit.state.quadCorners);
  }

  void _onQuadPanUpdate(
    DragUpdateDetails d,
    double imgW,
    double imgH,
    double ox,
    double oy,
  ) {
    if (_activeHandle == -1) return;
    final pos = _screenToNorm(d.localPosition, imgW, imgH, ox, oy);
    final delta = pos - _dragStartNorm;

    final newCorners = List<Offset>.from(_quadAtStart);
    if (_activeHandle >= 0 && _activeHandle < 4) {
      newCorners[_activeHandle] = Offset(
        (_quadAtStart[_activeHandle].dx + delta.dx).clamp(0, 1),
        (_quadAtStart[_activeHandle].dy + delta.dy).clamp(0, 1),
      );
    } else if (_activeHandle == 4) {
      final dx = delta.dx;
      final dy = delta.dy;
      final minX = _quadAtStart.map((c) => c.dx).reduce(min) + dx;
      final maxX = _quadAtStart.map((c) => c.dx).reduce(max) + dx;
      final minY = _quadAtStart.map((c) => c.dy).reduce(min) + dy;
      final maxY = _quadAtStart.map((c) => c.dy).reduce(max) + dy;

      if (minX >= 0 && maxX <= 1 && minY >= 0 && maxY <= 1) {
        for (int i = 0; i < 4; i++) {
          newCorners[i] = Offset(
            _quadAtStart[i].dx + dx,
            _quadAtStart[i].dy + dy,
          );
        }
      }
    }

    widget.cubit.setQuadCorners(newCorners);
  }

  int _hitTestCrop(Offset pos, Rect rect) {
    const double t = 0.04;
    if ((pos - rect.topLeft).distance <= t) return 0;
    if ((pos - rect.topRight).distance <= t) return 1;
    if ((pos - rect.bottomLeft).distance <= t) return 2;
    if ((pos - rect.bottomRight).distance <= t) return 3;
    if (rect.contains(pos)) return 4;
    return -1;
  }

  int _hitTestQuad(Offset pos, List<Offset> corners) {
    const double t = 0.04;
    for (int i = 0; i < 4; i++) {
      if ((pos - corners[i]).distance <= t) return i;
    }
    if (_isInsideQuad(pos, corners)) return 4;
    return -1;
  }

  bool _isInsideQuad(Offset p, List<Offset> corners) {
    bool inside = false;
    for (int i = 0, j = 3; i < 4; j = i++) {
      if ((corners[i].dy > p.dy) != (corners[j].dy > p.dy) &&
          p.dx <
              (corners[j].dx - corners[i].dx) *
                      (p.dy - corners[i].dy) /
                      (corners[j].dy - corners[i].dy) +
                  corners[i].dx) {
        inside = !inside;
      }
    }
    return inside;
  }

  List<Widget> _buildCropHandles(
    CropEditorState state,
    Offset Function(Offset) normToScreen,
  ) {
    final rect = state.cropRect;
    final corners = [
      rect.topLeft,
      rect.topRight,
      rect.bottomLeft,
      rect.bottomRight,
    ];
    return corners.map((c) {
      final screen = normToScreen(c);
      return Positioned(
        left: screen.dx - 12,
        top: screen.dy - 12,
        child: const CornerHandle(),
      );
    }).toList();
  }

  List<Widget> _buildQuadHandles(
    CropEditorState state,
    Offset Function(Offset) normToScreen,
  ) {
    return state.quadCorners.map((c) {
      final screen = normToScreen(c);
      return Positioned(
        left: screen.dx - 12,
        top: screen.dy - 12,
        child: const CornerHandle(),
      );
    }).toList();
  }
}
