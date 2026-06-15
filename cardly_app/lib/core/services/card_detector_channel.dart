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
}
