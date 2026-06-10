package com.example.cardly_app

import android.graphics.Bitmap
import org.opencv.android.Utils
import org.opencv.core.*
import org.opencv.imgproc.Imgproc
import kotlin.math.abs

object CardDetector {

    fun detect(bitmap: Bitmap): Boolean {
        val src = Mat()
        Utils.bitmapToMat(bitmap, src)

        val resized = Mat()
        val targetWidth = 640.0
        val scale = targetWidth / src.width()
        val targetHeight = src.height() * scale

        Imgproc.resize(
            src,
            resized,
            Size(targetWidth, targetHeight)
        )

        val gray = Mat()
        Imgproc.cvtColor(resized, gray, Imgproc.COLOR_RGBA2GRAY)

        val blurred = Mat()
        Imgproc.GaussianBlur(gray, blurred, Size(5.0, 5.0), 0.0)

        val edges = Mat()
        Imgproc.Canny(blurred, edges, 50.0, 150.0)

        val contours = mutableListOf<MatOfPoint>()
        val hierarchy = Mat()

        Imgproc.findContours(
            edges,
            contours,
            hierarchy,
            Imgproc.RETR_EXTERNAL,
            Imgproc.CHAIN_APPROX_SIMPLE
        )

        val imageArea = resized.width() * resized.height()

        for (contour in contours) {
            val area = Imgproc.contourArea(contour)

            if (area < imageArea * 0.08) continue
            if (area > imageArea * 0.85) continue

            val contour2f = MatOfPoint2f(*contour.toArray())
            val peri = Imgproc.arcLength(contour2f, true)

            val approx = MatOfPoint2f()
            Imgproc.approxPolyDP(contour2f, approx, 0.02 * peri, true)

            val points = approx.toArray()

            if (points.size != 4) continue

            val rect = Imgproc.boundingRect(MatOfPoint(*points))

            val ratio = rect.width.toDouble() / rect.height.toDouble()
            val normalizedRatio = if (ratio > 1) ratio else 1.0 / ratio

            // Business card thường gần 1.58, nhưng cho rộng ra để bắt được nhiều góc chụp.
            if (normalizedRatio < 1.35 || normalizedRatio > 1.9) continue

            val rectArea = rect.width * rect.height
            val fillRatio = area / rectArea

            if (fillRatio < 0.55) continue

            src.release()
            resized.release()
            gray.release()
            blurred.release()
            edges.release()
            hierarchy.release()

            return true
        }

        src.release()
        resized.release()
        gray.release()
        blurred.release()
        edges.release()
        hierarchy.release()

        return false
    }
}