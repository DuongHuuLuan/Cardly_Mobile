package com.example.cardly_app

import org.opencv.core.*
import org.opencv.imgproc.Imgproc
import kotlin.math.*

object CardDetector {
    fun detectFromYuv(
        width: Int,
        height: Int,
        y: ByteArray,
        yRowStride: Int
    ): Map<String, Any> {
        if (width <= 0 || height <= 0) return emptyResult()

        val gray = Mat(height, width, CvType.CV_8UC1)
        try {
            for (row in 0 until height) {
                val offset = row * yRowStride
                if (offset + width <= y.size) {
                    gray.put(row, 0, y, offset, width)
                }
            }
            return detectCard(gray)
        } catch (_: Exception) {
            return emptyResult()
        } finally {
            gray.release()
        }
    }

    private fun detectCard(gray: Mat): Map<String, Any> {
        var bestScore = 0.0
        var bestResult = emptyResult()

        val scaled = Mat()
        val edges = Mat()
        val hierarchy = Mat()
        val contours = mutableListOf<MatOfPoint>()

        try {
            val scale = min(1.0, 360.0 / gray.width())
            val rw = (gray.width() * scale).toInt()
            val rh = (gray.height() * scale).toInt()
            Imgproc.resize(gray, scaled, Size(rw.toDouble(), rh.toDouble()))

            Imgproc.GaussianBlur(scaled, scaled, Size(5.0, 5.0), 0.0)
            Imgproc.Canny(scaled, edges, 50.0, 150.0)
            Imgproc.findContours(
                edges, contours, hierarchy,
                Imgproc.RETR_EXTERNAL, Imgproc.CHAIN_APPROX_SIMPLE
            )

            val roiArea = rw.toDouble() * rh.toDouble()

            for (contour in contours) {
                val area = Imgproc.contourArea(contour)
                if (area < roiArea * 0.08) continue

                val c2f = MatOfPoint2f(*contour.toArray())
                val approx = MatOfPoint2f()

                try {
                    val peri = Imgproc.arcLength(c2f, true)
                    Imgproc.approxPolyDP(c2f, approx, peri * 0.02, true)

                    if (approx.toArray().size != 4) continue

                    val rect = Imgproc.minAreaRect(c2f)
                    val long = max(rect.size.width, rect.size.height)
                    val short = min(rect.size.width, rect.size.height)
                    if (short <= 0) continue

                    val ratio = long / short
                    if (ratio < 1.2 || ratio > 2.1) continue

                    val centerX = rect.center.x / rw
                    val centerY = rect.center.y / rh
                    val score = min(1.0, area / (roiArea * 0.4))

                    if (score > bestScore) {
                        bestScore = score
                        bestResult = mapOf(
                            "detected" to true,
                            "cx" to centerX,
                            "cy" to centerY,
                            "width" to long / rw,
                            "height" to short / rw,
                            "angle" to abs(
                                if (rect.size.width < rect.size.height)
                                    rect.angle + 90 else rect.angle
                            ),
                            "score" to score
                        )
                    }
                } finally {
                    c2f.release()
                    approx.release()
                }
            }

            return if (bestScore >= 0.30) bestResult else emptyResult()
        } finally {
            scaled.release()
            edges.release()
            hierarchy.release()
            contours.forEach { it.release() }
        }
    }

    private fun emptyResult() = mapOf(
        "detected" to false, "cx" to 0.0, "cy" to 0.0,
        "width" to 0.0, "height" to 0.0, "angle" to 0.0, "score" to 0.0
    )
}