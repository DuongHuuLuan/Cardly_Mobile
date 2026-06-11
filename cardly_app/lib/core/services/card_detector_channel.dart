import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:cardly_app/core/models/card_detection_result.dart';
import 'package:flutter/services.dart';
  
class CardDetectorChannel {
  static const MethodChannel _channel =
  MethodChannel('cardly/opencv_card_detector');

  static Future<bool> detectCard(Uint8List bytes) async {
    final result = await _channel.invokeMethod<bool>(
      'detectCard',
      {'bytes': bytes},
    );

    return result ?? false;
  }

  static Future<CardDetectionResult> detectCardFromYuv({
    required CameraImage image,
    required double overlayLeft,
    required double overlayTop,
    required double overlayWidth,
    required double overlayHeight,
    required double previewWidth,
    required double previewHeight,
  }) async {
    final result = await _channel.invokeMethod('detectCardFromYuv', {
      'width': image.width,
      'height': image.height,

      'y': image.planes[0].bytes,
      'u': image.planes[1].bytes,
      'v': image.planes[2].bytes,

      'yRowStride': image.planes[0].bytesPerRow,
      'uRowStride': image.planes[1].bytesPerRow,
      'vRowStride': image.planes[2].bytesPerRow,

      'uPixelStride': image.planes[1].bytesPerPixel ?? 1,
      'vPixelStride': image.planes[2].bytesPerPixel ?? 1,

      'overlayLeft': overlayLeft,
      'overlayTop': overlayTop,
      'overlayWidth': overlayWidth,
      'overlayHeight': overlayHeight,
      'previewWidth': previewWidth,
      'previewHeight': previewHeight,
    });

    return CardDetectionResult.fromMap(result);
  }
}