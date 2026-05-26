import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';

class CropOverlay extends StatefulWidget {
  final String imagePath;
  final Size imageSize;
  final ValueChanged<Rect> onConfirm;
  final VoidCallback onCancel;

  const CropOverlay({
    super.key,
    required this.imagePath,
    required this.imageSize,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<CropOverlay> createState() => _CropOverlayState();
}

class _CropOverlayState extends State<CropOverlay> {
  late Rect _normRect;
  int _activeHandle = -1;
  Offset _dragStartNorm = Offset.zero;
  Rect _rectAtDragNorm = Rect.zero;

  static const double _handleRadius = 12.0;
  static const double _minSize = 0.08;

  static const int _tl = 0, _tr = 1, _bl = 2, _br = 3, _move = 4;

  @override
  void initState() {
    super.initState();
    const m = 0.05;
    _normRect = Rect.fromLTWH(m, m, 1 - 2 * m, 1 - 2 * m);
  }

  int _hitTest(Offset normPoint) {
    final r = _normRect;
    const double t = 0.04;
    if ((normPoint - r.topLeft).distance <= t) return _tl;
    if ((normPoint - r.topRight).distance <= t) return _tr;
    if ((normPoint - r.bottomLeft).distance <= t) return _bl;
    if ((normPoint - r.bottomRight).distance <= t) return _br;
    if (r.contains(normPoint)) return _move;
    return -1;
  }

  void _onPanStart(DragStartDetails details, Size displaySize) {
    final normPos = Offset(
      details.localPosition.dx / displaySize.width,
      details.localPosition.dy / displaySize.height,
    );
    _activeHandle = _hitTest(normPos);
    _dragStartNorm = normPos;
    _rectAtDragNorm = _normRect;
  }

  void _onPanUpdate(DragUpdateDetails details, Size displaySize) {
    if (_activeHandle == -1) return;
    final normPos = Offset(
      details.localPosition.dx / displaySize.width,
      details.localPosition.dy / displaySize.height,
    );
    final delta = normPos - _dragStartNorm;
    final r = _rectAtDragNorm;

    setState(() {
      switch (_activeHandle) {
        case _tl:
          _normRect = Rect.fromLTRB(
            (r.left + delta.dx).clamp(0, r.right - _minSize),
            (r.top + delta.dy).clamp(0, r.bottom - _minSize),
            r.right,
            r.bottom,
          );
        case _tr:
          _normRect = Rect.fromLTRB(
            r.left,
            (r.top + delta.dy).clamp(0, r.bottom - _minSize),
            (r.right + delta.dx).clamp(r.left + _minSize, 1),
            r.bottom,
          );
        case _bl:
          _normRect = Rect.fromLTRB(
            (r.left + delta.dx).clamp(0, r.right - _minSize),
            r.top,
            r.right,
            (r.bottom + delta.dy).clamp(r.top + _minSize, 1),
          );
        case _br:
          _normRect = Rect.fromLTRB(
            r.left,
            r.top,
            (r.right + delta.dx).clamp(r.left + _minSize, 1),
            (r.bottom + delta.dy).clamp(r.top + _minSize, 1),
          );
        case _move:
          double l = r.left + delta.dx;
          double t = r.top + delta.dy;
          if (l < 0) l = 0;
          if (t < 0) t = 0;
          if (l + r.width > 1) l = 1 - r.width;
          if (t + r.height > 1) t = 1 - r.height;
          _normRect = Rect.fromLTWH(l, t, r.width, r.height);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _activeHandle = -1;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final displaySize = Size(constraints.maxWidth, constraints.maxHeight);
        final pixelCrop = Rect.fromLTWH(
          _normRect.left * displaySize.width,
          _normRect.top * displaySize.height,
          _normRect.width * displaySize.width,
          _normRect.height * displaySize.height,
        );

        return Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.file(
                      File(widget.imagePath),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned.fill(
                    child: ClipRect(
                      child: GestureDetector(
                        onPanStart: (d) => _onPanStart(d, displaySize),
                        onPanUpdate: (d) => _onPanUpdate(d, displaySize),
                        onPanEnd: _onPanEnd,
                        child: CustomPaint(
                          painter: _CropOverlayPainter(cropRect: pixelCrop),
                        ),
                      ),
                    ),
                  ),
                  ..._buildCornerHandles(pixelCrop),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        );
      },
    );
  }

  List<Widget> _buildCornerHandles(Rect pixelCrop) {
    final corners = [
      pixelCrop.topLeft,
      pixelCrop.topRight,
      pixelCrop.bottomLeft,
      pixelCrop.bottomRight,
    ];
    final size = _handleRadius * 2;
    return corners.map((corner) {
      return Positioned(
        left: corner.dx - _handleRadius,
        top: corner.dy - _handleRadius,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColor.white,
            border: Border.all(color: AppColor.primary, width: 2.5),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: widget.onCancel,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: AppElevatedButton(
              label: 'Apply',
              onPressed: () {
                widget.onConfirm(
                  Rect.fromLTWH(
                    _normRect.left * widget.imageSize.width,
                    _normRect.top * widget.imageSize.height,
                    _normRect.width * widget.imageSize.width,
                    _normRect.height * widget.imageSize.height,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CropOverlayPainter extends CustomPainter {
  final Rect cropRect;
  _CropOverlayPainter({required this.cropRect});

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = AppColor.black.withValues(alpha: 0.55);
    final outer = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final inner = Path()..addRect(cropRect);
    canvas.drawPath(
      Path.combine(PathOperation.reverseDifference, outer, inner),
      overlayPaint,
    );

    final borderPaint = Paint()
      ..color = AppColor.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(cropRect, borderPaint);

    final gridPaint = Paint()
      ..color = AppColor.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    for (int i = 1; i <= 2; i++) {
      final x = cropRect.left + cropRect.width * i / 3;
      final y = cropRect.top + cropRect.height * i / 3;
      canvas.drawLine(
        Offset(x, cropRect.top),
        Offset(x, cropRect.bottom),
        gridPaint,
      );
      canvas.drawLine(
        Offset(cropRect.left, y),
        Offset(cropRect.right, y),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CropOverlayPainter oldDelegate) =>
      oldDelegate.cropRect != cropRect;
}
