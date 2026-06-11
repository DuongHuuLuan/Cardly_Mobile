import 'package:flutter/material.dart';

class CameraFrameHelper {
  static Rect getFrameRect({
    required Size screen,
    required bool isLandscape,
  }) {
    final frameWidth = screen.width * 0.86;
    final frameHeight = isLandscape
        ? frameWidth * 0.62
        : frameWidth * 1.35;

    return Rect.fromCenter(
      center: Offset(screen.width / 2, screen.height / 2),
      width: frameWidth,
      height: frameHeight,
    );
  }
}