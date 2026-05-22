import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'perspective.dart';

class ImageProcessor {
  static Future<File> process({
    required String inputPath,
    required String outputPath,
    required double rotationDegrees,
    required Rect cropRect,
    bool usePerspective = false,
    List<Offset>? quadCorners,
  }) async {
    final bytes = await File(inputPath).readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) throw Exception('Failed to decode image');

    img.Image? image;

    if (usePerspective && quadCorners != null) {
      final pixelCorners = quadCorners
          .map((c) => Offset(c.dx * decoded.width, c.dy * decoded.height))
          .toList();
      image = warpPerspective(decoded, pixelCorners);
    } else {
      final pixelRect = Rect.fromLTWH(
        cropRect.left * decoded.width,
        cropRect.top * decoded.height,
        cropRect.width * decoded.width,
        cropRect.height * decoded.height,
      );
      image = img.copyCrop(
        decoded,
        x: pixelRect.left.round(),
        y: pixelRect.top.round(),
        width: pixelRect.width.round(),
        height: pixelRect.height.round(),
      );
    }

    if (rotationDegrees != 0) {
      image = rotateArbitrary(image, rotationDegrees);
    }

    final result = img.encodeJpg(image, quality: 95);
    await File(outputPath).writeAsBytes(result);
    return File(outputPath);
  }
}
