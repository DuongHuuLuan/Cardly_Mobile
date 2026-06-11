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
                "detectCardFromYuv" -> {
                    try {
                        val width = call.argument<Int>("width")!!
                        val height = call.argument<Int>("height")!!

                        val y = call.argument<ByteArray>("y")!!
                        val u = call.argument<ByteArray>("u")!!
                        val v = call.argument<ByteArray>("v")!!

                        val yRowStride = call.argument<Int>("yRowStride")!!
                        val uRowStride = call.argument<Int>("uRowStride")!!
                        val vRowStride = call.argument<Int>("vRowStride")!!

                        val uPixelStride = call.argument<Int>("uPixelStride")!!
                        val vPixelStride = call.argument<Int>("vPixelStride")!!

                        val overlayLeft = call.argument<Double>("overlayLeft")!!
                        val overlayTop = call.argument<Double>("overlayTop")!!
                        val overlayWidth = call.argument<Double>("overlayWidth")!!
                        val overlayHeight = call.argument<Double>("overlayHeight")!!

                        val previewWidth = call.argument<Double>("previewWidth")!!
                        val previewHeight = call.argument<Double>("previewHeight")!!

                        val detection = CardDetector.detectFromYuv(
                            width = width,
                            height = height,
                            y = y,
                            u = u,
                            v = v,
                            yRowStride = yRowStride,
                            uRowStride = uRowStride,
                            vRowStride = vRowStride,
                            uPixelStride = uPixelStride,
                            vPixelStride = vPixelStride,
                            overlayLeft = overlayLeft,
                            overlayTop = overlayTop,
                            overlayWidth = overlayWidth,
                            overlayHeight = overlayHeight,
                            previewWidth = previewWidth,
                            previewHeight = previewHeight
                        )

                        result.success(detection)
                    } catch (e: Exception) {
                        result.success(
                            mapOf(
                                "detected" to false,
                                "cx" to 0.0,
                                "cy" to 0.0,
                                "width" to 0.0,
                                "height" to 0.0,
                                "angle" to 0.0,
                                "score" to 0.0
                            )
                        )
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}