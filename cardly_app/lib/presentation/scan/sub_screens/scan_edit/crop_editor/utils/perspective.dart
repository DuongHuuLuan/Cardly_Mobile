import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';

List<List<double>> _createMatrix(int rows, int cols) =>
    List.generate(rows, (_) => List.filled(cols, 0.0));

List<double> _solveLinearSystem(List<List<double>> A, List<double> b) {
  final n = A.length;
  final augmented = List.generate(n, (i) => [...A[i], b[i]]);

  for (int col = 0; col < n; col++) {
    int maxRow = col;
    double maxVal = augmented[col][col].abs();
    for (int row = col + 1; row < n; row++) {
      if (augmented[row][col].abs() > maxVal) {
        maxVal = augmented[row][col].abs();
        maxRow = row;
      }
    }

    final temp = augmented[col];
    augmented[col] = augmented[maxRow];
    augmented[maxRow] = temp;

    for (int row = col + 1; row < n; row++) {
      final factor = augmented[row][col] / augmented[col][col];
      for (int j = col; j <= n; j++) {
        augmented[row][j] -= factor * augmented[col][j];
      }
    }
  }

  final x = List.filled(n, 0.0);
  for (int i = n - 1; i >= 0; i--) {
    double sum = augmented[i][n];
    for (int j = i + 1; j < n; j++) {
      sum -= augmented[i][j] * x[j];
    }
    x[i] = sum / augmented[i][i];
  }

  return x;
}

List<List<double>> getPerspectiveTransform(List<Offset> src, List<Offset> dst) {
  final A = _createMatrix(8, 8);
  final b = List.filled(8, 0.0);

  for (int i = 0; i < 4; i++) {
    final sx = src[i].dx, sy = src[i].dy;
    final dx = dst[i].dx, dy = dst[i].dy;

    A[2 * i][0] = sx;
    A[2 * i][1] = sy;
    A[2 * i][2] = 1;
    A[2 * i][3] = 0;
    A[2 * i][4] = 0;
    A[2 * i][5] = 0;
    A[2 * i][6] = -sx * dx;
    A[2 * i][7] = -sy * dx;
    b[2 * i] = dx;

    A[2 * i + 1][0] = 0;
    A[2 * i + 1][1] = 0;
    A[2 * i + 1][2] = 0;
    A[2 * i + 1][3] = sx;
    A[2 * i + 1][4] = sy;
    A[2 * i + 1][5] = 1;
    A[2 * i + 1][6] = -sx * dy;
    A[2 * i + 1][7] = -sy * dy;
    b[2 * i + 1] = dy;
  }

  final h = _solveLinearSystem(A, b);

  return [
    [h[0], h[1], h[2]],
    [h[3], h[4], h[5]],
    [h[6], h[7], 1.0],
  ];
}

Offset _applyMatrix(List<List<double>> m, double x, double y) {
  final z = m[2][0] * x + m[2][1] * y + m[2][2];
  if (z.abs() < 1e-10) return Offset.zero;
  return Offset(
    (m[0][0] * x + m[0][1] * y + m[0][2]) / z,
    (m[1][0] * x + m[1][1] * y + m[1][2]) / z,
  );
}

num _lerp(num a, num b, double t) => a + (b - a) * t;

img.Color _bilinearSample(img.Image src, double x, double y) {
  final x0 = x.floor().clamp(0, src.width - 1);
  final x1 = (x0 + 1).clamp(0, src.width - 1);
  final y0 = y.floor().clamp(0, src.height - 1);
  final y1 = (y0 + 1).clamp(0, src.height - 1);
  final fx = x - x0;
  final fy = y - y0;

  final c00 = src.getPixel(x0, y0);
  final c10 = src.getPixel(x1, y0);
  final c01 = src.getPixel(x0, y1);
  final c11 = src.getPixel(x1, y1);

  final r = _lerp(_lerp(c00.r, c10.r, fx), _lerp(c01.r, c11.r, fx), fy);
  final g = _lerp(_lerp(c00.g, c10.g, fx), _lerp(c01.g, c11.g, fx), fy);
  final b = _lerp(_lerp(c00.b, c10.b, fx), _lerp(c01.b, c11.b, fx), fy);
  final a = _lerp(_lerp(c00.a, c10.a, fx), _lerp(c01.a, c11.a, fx), fy);

  return img.ColorRgba8(
    r.round().clamp(0, 255),
    g.round().clamp(0, 255),
    b.round().clamp(0, 255),
    a.round().clamp(0, 255),
  );
}

img.Image warpPerspective(img.Image src, List<Offset> quadCorners) {
  final minX = quadCorners
      .map((c) => c.dx)
      .reduce(min)
      .floor()
      .clamp(0, src.width - 1);
  final minY = quadCorners
      .map((c) => c.dy)
      .reduce(min)
      .floor()
      .clamp(0, src.height - 1);
  final maxX = quadCorners
      .map((c) => c.dx)
      .reduce(max)
      .ceil()
      .clamp(0, src.width);
  final maxY = quadCorners
      .map((c) => c.dy)
      .reduce(max)
      .ceil()
      .clamp(0, src.height);

  final dstWidth = (maxX - minX).ceil();
  final dstHeight = (maxY - minY).ceil();

  if (dstWidth <= 0 || dstHeight <= 0) return img.Image(width: 1, height: 1);

  final dstQuad = [
    Offset(0, 0),
    Offset(dstWidth - 1, 0),
    Offset(dstWidth - 1, dstHeight - 1),
    Offset(0, dstHeight - 1),
  ];

  final hInv = getPerspectiveTransform(dstQuad, quadCorners);

  final dst = img.Image(width: dstWidth, height: dstHeight, numChannels: 4);

  for (int y = 0; y < dstHeight; y++) {
    for (int x = 0; x < dstWidth; x++) {
      final srcPoint = _applyMatrix(hInv, x.toDouble(), y.toDouble());
      if (srcPoint.dx >= 0 &&
          srcPoint.dx < src.width - 1 &&
          srcPoint.dy >= 0 &&
          srcPoint.dy < src.height - 1) {
        dst.setPixel(x, y, _bilinearSample(src, srcPoint.dx, srcPoint.dy));
      }
    }
  }

  return dst;
}

img.Image rotateArbitrary(img.Image src, double angleDeg) {
  if (angleDeg.abs() < 0.001) return src;

  final rad = angleDeg * (pi / 180);
  final cosA = cos(rad).abs();
  final sinA = sin(rad).abs();

  final newW = (src.width * cosA + src.height * sinA).ceil();
  final newH = (src.width * sinA + src.height * cosA).ceil();

  final cx = src.width / 2;
  final cy = src.height / 2;
  final ncx = newW / 2;
  final ncy = newH / 2;

  final cosNeg = cos(-rad);
  final sinNeg = sin(-rad);

  final dst = img.Image(width: newW, height: newH, numChannels: 4);

  for (int y = 0; y < newH; y++) {
    for (int x = 0; x < newW; x++) {
      final dx = x - ncx;
      final dy = y - ncy;
      final sx = dx * cosNeg - dy * sinNeg + cx;
      final sy = dx * sinNeg + dy * cosNeg + cy;

      if (sx >= 0 && sx < src.width - 1 && sy >= 0 && sy < src.height - 1) {
        dst.setPixel(x, y, _bilinearSample(src, sx, sy));
      }
    }
  }

  return dst;
}
