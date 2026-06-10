package com.example.cardly_app

import android.graphics.BitmapFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.opencv.android.OpenCVLoader

class MainActivity : FlutterActivity() {
    private val CHANNEL = "cardly/opencv_card_detector"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        OpenCVLoader.initLocal()

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "detectCard" -> {
                    val bytes = call.argument<ByteArray>("bytes")

                    if (bytes == null) {
                        result.error("INVALID_BYTES", "Image bytes is null", null)
                        return@setMethodCallHandler
                    }

                    val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)

                    if (bitmap == null) {
                        result.error("DECODE_ERROR", "Cannot decode bitmap", null)
                        return@setMethodCallHandler
                    }

                    val detected = CardDetector.detect(bitmap)
                    result.success(detected)
                }

                else -> result.notImplemented()
            }
        }
    }
}