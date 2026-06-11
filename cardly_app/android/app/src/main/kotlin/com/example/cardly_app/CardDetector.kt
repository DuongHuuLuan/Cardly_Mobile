package com.example.cardly_app

import android.util.Log
import org.opencv.core.*
import org.opencv.imgproc.Imgproc
import kotlin.math.*

object CardDetector {

    private const val TAG = "CardDetector"
    private const val DEBUG = true

    /**
     * Card chuẩn thường gần tỉ lệ ID / bank card:
     * 85.60 / 53.98 = 1.586
     */
    private const val CARD_RATIO = 1.586

    fun detectFromYuv(
        width: Int,
        height: Int,
        y: ByteArray,
        u: ByteArray,
        v: ByteArray,
        yRowStride: Int,
        uRowStride: Int,
        vRowStride: Int,
        uPixelStride: Int,
        vPixelStride: Int,
        overlayLeft: Double,
        overlayTop: Double,
        overlayWidth: Double,
        overlayHeight: Double,
        previewWidth: Double,
        previewHeight: Double
    ): Map<String, Any> {
        if (width <= 0 || height <= 0) return emptyResult()
        if (previewWidth <= 0.0 || previewHeight <= 0.0) return emptyResult()

        val gray = Mat(height, width, CvType.CV_8UC1)

        try {
            for (row in 0 until height) {
                val yOffset = row * yRowStride
                if (yOffset + width <= y.size) {
                    gray.put(row, 0, y, yOffset, width)
                }
            }

            return detectCardFromGray(
                gray = gray,
                overlayLeft = overlayLeft,
                overlayTop = overlayTop,
                overlayWidth = overlayWidth,
                overlayHeight = overlayHeight,
                previewWidth = previewWidth,
                previewHeight = previewHeight
            )
        } catch (e: Exception) {
            if (DEBUG) Log.e(TAG, "detectFromYuv error", e)
            return emptyResult()
        } finally {
            gray.release()
        }
    }

    private fun emptyResult(): Map<String, Any> {
        return mapOf(
            "detected" to false,
            "cx" to 0.0,
            "cy" to 0.0,
            "width" to 0.0,
            "height" to 0.0,
            "angle" to 0.0,
            "score" to 0.0
        )
    }

    private fun detectCardFromGray(
        gray: Mat,
        overlayLeft: Double,
        overlayTop: Double,
        overlayWidth: Double,
        overlayHeight: Double,
        previewWidth: Double,
        previewHeight: Double
    ): Map<String, Any> {
        if (gray.empty()) return emptyResult()

        val frameW = gray.width()
        val frameH = gray.height()

        val roiRect = mapOverlayToFrameRoi(
            frameWidth = frameW,
            frameHeight = frameH,
            overlayLeft = overlayLeft,
            overlayTop = overlayTop,
            overlayWidth = overlayWidth,
            overlayHeight = overlayHeight,
            previewWidth = previewWidth,
            previewHeight = previewHeight
        ) ?: return emptyResult()

        val roi = Mat(gray, roiRect)
        val resized = Mat()
        val blurred = Mat()
        val equalized = Mat()
        val edges = Mat()
        val hierarchy = Mat()
        val contours = mutableListOf<MatOfPoint>()

        var closeKernel: Mat? = null
        var dilateKernel: Mat? = null

        try {
            val targetWidth = 520.0
            val scale = targetWidth / roi.width().toDouble()
            val targetHeight = roi.height() * scale

            Imgproc.resize(roi, resized, Size(targetWidth, targetHeight))

            Imgproc.GaussianBlur(
                resized,
                blurred,
                Size(5.0, 5.0),
                0.0
            )

            Imgproc.equalizeHist(blurred, equalized)

            Imgproc.Canny(
                equalized,
                edges,
                45.0,
                130.0
            )

            closeKernel = Imgproc.getStructuringElement(
                Imgproc.MORPH_RECT,
                Size(9.0, 9.0)
            )

            Imgproc.morphologyEx(
                edges,
                edges,
                Imgproc.MORPH_CLOSE,
                closeKernel
            )

            dilateKernel = Imgproc.getStructuringElement(
                Imgproc.MORPH_RECT,
                Size(3.0, 3.0)
            )

            Imgproc.dilate(edges, edges, dilateKernel)

            Imgproc.findContours(
                edges,
                contours,
                hierarchy,
                Imgproc.RETR_EXTERNAL,
                Imgproc.CHAIN_APPROX_SIMPLE
            )

            val roiArea = resized.width() * resized.height()
            var bestScore = 0.0
            var bestResult = emptyResult()

            for (contour in contours) {
                val area = Imgproc.contourArea(contour)

                if (area < roiArea * 0.28) continue
                if (area > roiArea * 0.92) continue

                val contour2f = MatOfPoint2f(*contour.toArray())
                val approx2f = MatOfPoint2f()

                try {
                    val perimeter = Imgproc.arcLength(contour2f, true)
                    if (perimeter <= 0.0) continue

                    Imgproc.approxPolyDP(
                        contour2f,
                        approx2f,
                        perimeter * 0.025,
                        true
                    )

                    val approxPoints = approx2f.toArray()

                    /**
                     * Quan trọng:
                     * Card phải gần 4 góc.
                     * Hình chữ nhật méo nhẹ có thể ra 4-6 điểm.
                     * Nếu quá nhiều điểm thì thường là vật thể/texture khác.
                     */
                    if (approxPoints.size < 4 || approxPoints.size > 6) continue

                    val approxPointMat = MatOfPoint(*approxPoints)
                    val isConvex = Imgproc.isContourConvex(approxPointMat)
                    approxPointMat.release()

                    if (!isConvex) continue

                    val rect = Imgproc.minAreaRect(contour2f)

                    val rw = rect.size.width
                    val rh = rect.size.height

                    if (rw <= 0.0 || rh <= 0.0) continue

                    val longSide = max(rw, rh)
                    val shortSide = min(rw, rh)
                    val ratio = longSide / shortSide

                    /**
                     * Siết mạnh để tránh nhận bừa giấy, hộp, hình vuông.
                     */
                    if (ratio < 1.45 || ratio > 1.75) continue

                    val rectArea = rw * rh
                    val rectangularity = area / rectArea

                    /**
                     * Contour card thật thường lấp khá kín minAreaRect.
                     * Nếu thấp quá: chỉ là cạnh rời / vật thể lạ.
                     * Nếu cao bất thường: contour lỗi.
                     */
                    if (rectangularity < 0.58 || rectangularity > 1.08) continue

                    val bounding = Imgproc.boundingRect(contour)
                    val boundingAreaRatio =
                        (bounding.width * bounding.height).toDouble() / roiArea.toDouble()

                    if (boundingAreaRatio < 0.30 || boundingAreaRatio > 0.95) continue

                    var angle = rect.angle.toDouble()
                    if (rw < rh) angle += 90.0
                    angle = abs(angle)

                    /**
                     * Vì người dùng đặt card trong overlay, không nên chấp nhận nghiêng quá nhiều.
                     */
                    if (angle > 18.0) continue

                    val centerX = rect.center.x / resized.width().toDouble()
                    val centerY = rect.center.y / resized.height().toDouble()

                    val centerDx = abs(centerX - 0.5)
                    val centerDy = abs(centerY - 0.5)

                    if (centerDx > 0.28 || centerDy > 0.28) continue

                    val angleQuality = checkCornerAngles(rect)
                    if (angleQuality < 0.72) continue

                    val edgeDensity = countNonZeroSafe(edges) / roiArea.toDouble()

                    /**
                     * Nếu edge quá ít: nền trơn / vùng không rõ card.
                     * Nếu edge quá nhiều: cảnh phức tạp, chữ, bàn phím, màn hình...
                     */
                    if (edgeDensity < 0.012 || edgeDensity > 0.22) continue

                    val areaScore = normalizeScore(
                        value = area / roiArea.toDouble(),
                        best = 0.62,
                        tolerance = 0.34
                    )

                    val ratioScore = normalizeScore(
                        value = ratio,
                        best = CARD_RATIO,
                        tolerance = 0.18
                    )

                    val rectangularityScore = normalizeScore(
                        value = rectangularity,
                        best = 0.82,
                        tolerance = 0.28
                    )

                    val angleScore = 1.0 - min(1.0, angle / 18.0)

                    val centerScore = 1.0 - min(
                        1.0,
                        (centerDx + centerDy) / 0.42
                    )

                    val cornerScore = angleQuality

                    val edgeScore = when {
                        edgeDensity < 0.012 -> 0.0
                        edgeDensity > 0.22 -> 0.0
                        else -> 1.0
                    }

                    val score =
                        ratioScore * 0.28 +
                                rectangularityScore * 0.22 +
                                areaScore * 0.16 +
                                angleScore * 0.14 +
                                centerScore * 0.12 +
                                cornerScore * 0.06 +
                                edgeScore * 0.02

                    if (score > bestScore) {
                        bestScore = score

                        bestResult = mapOf(
                            "detected" to true,
                            "cx" to centerX,
                            "cy" to centerY,
                            "width" to longSide / resized.width().toDouble(),
                            "height" to shortSide / resized.height().toDouble(),
                            "angle" to angle,
                            "score" to score
                        )
                    }
                } finally {
                    contour2f.release()
                    approx2f.release()
                }
            }

            return if (bestScore >= 0.68) bestResult else emptyResult()
        } catch (e: Exception) {
            if (DEBUG) Log.e(TAG, "detectCardFromGray error", e)
            return emptyResult()
        } finally {
            roi.release()
            resized.release()
            blurred.release()
            equalized.release()
            edges.release()
            hierarchy.release()
            closeKernel?.release()
            dilateKernel?.release()

            for (contour in contours) {
                contour.release()
            }
        }
    }

    private fun normalizeScore(
        value: Double,
        best: Double,
        tolerance: Double
    ): Double {
        return 1.0 - min(1.0, abs(value - best) / tolerance)
    }

    private fun countNonZeroSafe(mat: Mat): Int {
        return try {
            Core.countNonZero(mat)
        } catch (_: Exception) {
            0
        }
    }

    private fun checkCornerAngles(rect: RotatedRect): Double {
        val points = Array(4) { Point() }
        rect.points(points)

        val angles = mutableListOf<Double>()

        for (i in 0 until 4) {
            val prev = points[(i + 3) % 4]
            val curr = points[i]
            val next = points[(i + 1) % 4]

            val angle = angleBetween(prev, curr, next)
            angles.add(angle)
        }

        val avgError = angles.map { abs(it - 90.0) }.average()

        return 1.0 - min(1.0, avgError / 25.0)
    }

    private fun angleBetween(
        p1: Point,
        p2: Point,
        p3: Point
    ): Double {
        val v1x = p1.x - p2.x
        val v1y = p1.y - p2.y
        val v2x = p3.x - p2.x
        val v2y = p3.y - p2.y

        val dot = v1x * v2x + v1y * v2y
        val mag1 = sqrt(v1x * v1x + v1y * v1y)
        val mag2 = sqrt(v2x * v2x + v2y * v2y)

        if (mag1 <= 0.0 || mag2 <= 0.0) return 0.0

        val cosValue = (dot / (mag1 * mag2)).coerceIn(-1.0, 1.0)

        return Math.toDegrees(acos(cosValue))
    }

    private fun mapOverlayToFrameRoi(
        frameWidth: Int,
        frameHeight: Int,
        overlayLeft: Double,
        overlayTop: Double,
        overlayWidth: Double,
        overlayHeight: Double,
        previewWidth: Double,
        previewHeight: Double
    ): Rect? {
        if (frameWidth <= 0 || frameHeight <= 0) return null
        if (overlayWidth <= 0.0 || overlayHeight <= 0.0) return null
        if (previewWidth <= 0.0 || previewHeight <= 0.0) return null

        val frameIsLandscape = frameWidth >= frameHeight
        val previewIsLandscape = previewWidth >= previewHeight

        val rawLeft: Double
        val rawTop: Double
        val rawRight: Double
        val rawBottom: Double

        if (frameIsLandscape == previewIsLandscape) {
            val scaleX = frameWidth / previewWidth
            val scaleY = frameHeight / previewHeight

            rawLeft = overlayLeft * scaleX
            rawTop = overlayTop * scaleY
            rawRight = (overlayLeft + overlayWidth) * scaleX
            rawBottom = (overlayTop + overlayHeight) * scaleY
        } else {
            val scaleX = frameWidth / previewHeight
            val scaleY = frameHeight / previewWidth

            val pLeft = overlayLeft
            val pTop = overlayTop
            val pRight = overlayLeft + overlayWidth
            val pBottom = overlayTop + overlayHeight

            rawLeft = pTop * scaleX
            rawRight = pBottom * scaleX

            rawTop = (previewWidth - pRight) * scaleY
            rawBottom = (previewWidth - pLeft) * scaleY
        }

        var x = rawLeft.toInt()
        var y = rawTop.toInt()
        var w = (rawRight - rawLeft).toInt()
        var h = (rawBottom - rawTop).toInt()

        val paddingX = (w * 0.06).toInt()
        val paddingY = (h * 0.06).toInt()

        x -= paddingX
        y -= paddingY
        w += paddingX * 2
        h += paddingY * 2

        x = x.coerceIn(0, frameWidth - 1)
        y = y.coerceIn(0, frameHeight - 1)
        w = w.coerceIn(1, frameWidth - x)
        h = h.coerceIn(1, frameHeight - y)

        return Rect(x, y, w, h)
    }
}