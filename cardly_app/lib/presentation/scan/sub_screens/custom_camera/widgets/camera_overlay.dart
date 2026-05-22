import 'package:flutter/material.dart';

class CameraOverlay extends StatelessWidget {
  final bool isLandscape;
  const CameraOverlay({super.key, required this.isLandscape});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final frameWidth = size.width * 0.85;
    final frameHeight = isLandscape ? frameWidth * 0.62 : frameWidth * 1.35;
    return CustomPaint(
      size: size,
      painter: _OverlayPainter(
        frameRect: Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2 - 40),
          width: frameWidth,
          height: frameHeight,
        ),
      ),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final Rect frameRect;
  _OverlayPainter({required this.frameRect});

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(frameRect, const Radius.circular(16));

    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;

    final overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    canvas.drawPath(backgroundPath, overlayPaint);

    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _OverlayPainter oldDelegate) =>
      oldDelegate.frameRect != frameRect;
}
