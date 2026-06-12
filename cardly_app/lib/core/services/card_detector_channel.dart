import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:cardly_app/core/models/card_detection_result.dart';
import 'package:flutter/services.dart';

class CardDetectorChannel {
  static const MethodChannel _channel = MethodChannel(
    'cardly/opencv_card_detector',
  );

  static Future<bool> detectCard(Uint8List bytes) async {
    final result = await _channel.invokeMethod<bool>('detectCard', {
      'bytes': bytes,
    });
    return result ?? false;
  }

  static Future<CardDetectionResult> detectCardFromYuv({
    required CameraImage image,
  }) async {
    final result = await _channel.invokeMethod('detectCardFromYuv', {
      'width': image.width,
      'height': image.height,
      'y': image.planes[0].bytes,
      'yRowStride': image.planes[0].bytesPerRow,
    });
    return CardDetectionResult.fromMap(result);
  }
}
