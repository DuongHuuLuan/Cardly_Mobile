import 'package:cardly_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class CropOverlayPainter extends CustomPainter {
  final Rect cropRect;
  final double cornerBracketLength;
  CropOverlayPainter({required this.cropRect, this.cornerBracketLength = 20});

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

    final bracketPaint = Paint()
      ..color = AppColor.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final len = cornerBracketLength;
    final r = cropRect;

    // Top-left
    canvas.drawLine(
      Offset(r.left, r.top),
      Offset(r.left + len, r.top),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(r.left, r.top),
      Offset(r.left, r.top + len),
      bracketPaint,
    );
    // Top-right
    canvas.drawLine(
      Offset(r.right, r.top),
      Offset(r.right - len, r.top),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(r.right, r.top),
      Offset(r.right, r.top + len),
      bracketPaint,
    );
    // Bottom-left
    canvas.drawLine(
      Offset(r.left, r.bottom),
      Offset(r.left + len, r.bottom),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(r.left, r.bottom),
      Offset(r.left, r.bottom - len),
      bracketPaint,
    );
    // Bottom-right
    canvas.drawLine(
      Offset(r.right, r.bottom),
      Offset(r.right - len, r.bottom),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(r.right, r.bottom),
      Offset(r.right, r.bottom - len),
      bracketPaint,
    );

    final borderPaint = Paint()
      ..color = AppColor.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRect(cropRect, borderPaint);

    final gridPaint = Paint()
      ..color = AppColor.white.withValues(alpha: 0.4)
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
  bool shouldRepaint(CropOverlayPainter oldDelegate) =>
      oldDelegate.cropRect != cropRect;
}

class PerspectiveOverlayPainter extends CustomPainter {
  final List<Offset> corners;
  final double cornerBracketLength;

  PerspectiveOverlayPainter({
    required this.corners,
    this.cornerBracketLength = 20,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (corners.length != 4) return;

    final overlayPaint = Paint()
      ..color = AppColor.black.withValues(alpha: 0.55);
    final outer = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final inner = Path()..addPolygon(corners, true);
    canvas.drawPath(
      Path.combine(PathOperation.reverseDifference, outer, inner),
      overlayPaint,
    );

    final bracketPaint = Paint()
      ..color = AppColor.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final len = cornerBracketLength;

    for (int i = 0; i < 4; i++) {
      final c = corners[i];
      final prev = corners[(i - 1 + 4) % 4];
      final next = corners[(i + 1) % 4];

      final toPrev = prev - c;
      final toNext = next - c;
      final distPrev = toPrev.distance;
      final distNext = toNext.distance;

      if (distPrev > 0) {
        final dir = toPrev / distPrev;
        canvas.drawLine(c, c + dir * len, bracketPaint);
      }
      if (distNext > 0) {
        final dir = toNext / distNext;
        canvas.drawLine(c, c + dir * len, bracketPaint);
      }
    }

    final linePaint = Paint()
      ..color = AppColor.greyLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(Path()..addPolygon(corners, true), linePaint);

    final gridPaint = Paint()
      ..color = AppColor.greyLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int i = 0; i < 4; i++) {
      final next = (i + 1) % 4;
      final prev = (i - 1 + 4) % 4;
      final mid1 = Offset(
        (corners[i].dx + corners[next].dx) / 2,
        (corners[i].dy + corners[next].dy) / 2,
      );
      final mid2 = Offset(
        (corners[prev].dx + corners[i].dx) / 2,
        (corners[prev].dy + corners[i].dy) / 2,
      );
      canvas.drawLine(mid1, mid2, gridPaint);
    }
  }

  @override
  bool shouldRepaint(PerspectiveOverlayPainter oldDelegate) =>
      oldDelegate.corners != corners;
}
