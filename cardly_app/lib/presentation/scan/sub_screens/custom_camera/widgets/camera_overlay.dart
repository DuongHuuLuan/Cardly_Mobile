import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/utils/camera_frame_helper.dart';
import 'package:cardly_app/presentation/scan/sub_screens/custom_camera/custom_camera_screen.dart';
import 'package:flutter/material.dart';

class CameraOverlay extends StatefulWidget {
  final bool isLandscape;
  final AutoCaptureStatus status;

  const CameraOverlay({
    super.key,
    required this.isLandscape,
    required this.status,
  });

  @override
  State<CameraOverlay> createState() => _CameraOverlayState();
}

class _CameraOverlayState extends State<CameraOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  Color get _borderColor {
    switch (widget.status) {
      case AutoCaptureStatus.checking:
        return Colors.redAccent;
      case AutoCaptureStatus.ready:
        return Colors.greenAccent;
      case AutoCaptureStatus.capturing:
        return AppColor.white;
    }
  }

  String get _message {
    switch (widget.status) {
      case AutoCaptureStatus.checking:
        return "Insert the card into the frame.";
      case AutoCaptureStatus.ready:
        return "Hold still, preparing to capture...";
      case AutoCaptureStatus.capturing:
        return "Capturing...";
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    final frameRect = CameraFrameHelper.getFrameRect(
      screen: screen,
      isLandscape: widget.isLandscape,
    );

    return Stack(
      children: [
        CustomPaint(
          size: Size.infinite,
          painter: _CameraOverlayPainter(
            frameRect: frameRect,
            borderColor: _borderColor,
          ),
        ),

        AnimatedBuilder(
          animation: _scanController,
          builder: (context, child) {
            final scanY =
                frameRect.top + frameRect.height * _scanController.value;

            return Positioned(
              left: frameRect.left + 20,
              top: scanY,
              width: frameRect.width - 40,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: _borderColor,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: _borderColor.withValues(alpha: 0.8),
                      blurRadius: 14,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        Positioned(
          top: frameRect.bottom + 24,
          left: 0,
          right: 0,
          child: Text(
            _message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColor.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _CameraOverlayPainter extends CustomPainter {
  final Rect frameRect;
  final Color borderColor;

  _CameraOverlayPainter({required this.frameRect, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = AppColor.black.withValues(alpha: 0.58);

    final clearPaint = Paint()..blendMode = BlendMode.clear;

    canvas.saveLayer(Offset.zero & size, Paint());

    canvas.drawRect(Offset.zero & size, overlayPaint);

    final frameRRect = RRect.fromRectAndRadius(
      frameRect,
      const Radius.circular(22),
    );

    canvas.drawRRect(frameRRect, clearPaint);

    canvas.restore();

    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(frameRRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _CameraOverlayPainter oldDelegate) {
    return oldDelegate.frameRect != frameRect ||
        oldDelegate.borderColor != borderColor;
  }
}
