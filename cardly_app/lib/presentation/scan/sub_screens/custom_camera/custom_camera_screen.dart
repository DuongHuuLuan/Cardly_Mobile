import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cardly_app/core/services/card_detector_channel.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_alert_dialog.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_state.dart';
import 'package:cardly_app/presentation/scan/sub_screens/custom_camera/widgets/camera_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

enum AutoCaptureStatus { checking, ready, capturing }

class CustomCameraScreen extends StatefulWidget {
  static const routerName = "scan-custom-camera";

  const CustomCameraScreen({super.key});

  @override
  State<CustomCameraScreen> createState() => _CustomCameraScreenState();
}

class _CustomCameraScreenState extends State<CustomCameraScreen>
    with WidgetsBindingObserver {
  late final ScanCubit cubit;

  CameraController? _controller;

  bool _isReady = false;
  bool _isLandscape = true;

  FlashMode _flashMode = FlashMode.off;

  Timer? _autoCheckTimer;
  Timer? _readyTimer;

  bool _hasCaptured = false;
  bool _autoCaptureEnabled = true;
  bool _isAutoCapturing = false;
  bool _isDetectingCard = false;

  AutoCaptureStatus _autoStatus = AutoCaptureStatus.checking;

  double _currentZoom = 1.0;
  double _baseZoom = 1.0;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _lastAppliedZoom = 1.0;

  static const Duration _checkInterval = Duration(seconds: 3);
  static const Duration _readyDelay = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    cubit = context.read<ScanCubit>();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    // context.showLoading("Initializing camera...");
    try {
      final controller = await cubit.getCameraController();

      _minZoom = await controller.getMinZoomLevel();
      _maxZoom = await controller.getMaxZoomLevel();

      _currentZoom = _minZoom;
      _baseZoom = _currentZoom;
      _lastAppliedZoom = _currentZoom;

      await controller.setZoomLevel(_currentZoom);

      if (!mounted) return;

      setState(() {
        _controller = controller;
        _isReady = true;
        _hasCaptured = false;
        _isAutoCapturing = false;
        _isDetectingCard = false;
        _autoCaptureEnabled = true;
        _autoStatus = AutoCaptureStatus.checking;
      });
      // context.hideLoading();
      _startAutoCapture();
    } catch (_) {
      if (mounted) _showCameraUnavailableDialog();
    }
  }

  void _startAutoCapture() {
    _autoCheckTimer?.cancel();

    _autoCheckTimer = Timer.periodic(_checkInterval, (_) async {
      if (!_autoCaptureEnabled) return;
      if (!mounted) return;
      if (_controller == null || !_controller!.value.isInitialized) return;
      if (_controller!.value.isTakingPicture) return;
      if (_isAutoCapturing) return;
      if (_isDetectingCard) return;
      if (cubit.state.imagePaths.length >= 2) return;

      bool isReady = false;

      _isDetectingCard = true;
      try {
        isReady = await _checkCardReady();
      } finally {
        _isDetectingCard = false;
      }

      if (!mounted) return;

      if (isReady) {
        if (_autoStatus != AutoCaptureStatus.ready) {
          setState(() {
            _autoStatus = AutoCaptureStatus.ready;
          });

          _readyTimer?.cancel();
          _readyTimer = Timer(_readyDelay, () async {
            if (!mounted) return;
            if (_autoStatus == AutoCaptureStatus.ready) {
              await _autoTakePicture();
            }
          });
        }
      } else {
        _readyTimer?.cancel();

        if (_autoStatus != AutoCaptureStatus.checking) {
          setState(() {
            _autoStatus = AutoCaptureStatus.checking;
          });
        }
      }
    });
  }

  Future<bool> _checkCardReady() async {
    if (_controller == null || !_controller!.value.isInitialized) return false;
    if (_controller!.value.isTakingPicture) return false;
    if (_hasCaptured || _isAutoCapturing) return false;

    try {
      final tempFile = await _controller!.takePicture();
      final bytes = await File(tempFile.path).readAsBytes();

      final detected = await CardDetectorChannel.detectCard(bytes);

      try {
        await File(tempFile.path).delete();
      } catch (_) {}

      return detected;
    } catch (_) {
      return false;
    }
  }

  Future<void> _autoTakePicture() async {
    if (_hasCaptured) return;
    if (_isAutoCapturing) return;
    if (_isDetectingCard) return;
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_controller!.value.isTakingPicture) return;

    _hasCaptured = true;
    _isAutoCapturing = true;
    _autoCaptureEnabled = false;

    _autoCheckTimer?.cancel();
    _readyTimer?.cancel();

    if (mounted) {
      setState(() {
        _autoStatus = AutoCaptureStatus.capturing;
      });
    }

    await _takePicture();
  }

  Future<void> _takePicture() async {
    _autoCaptureEnabled = false;
    _autoCheckTimer?.cancel();
    _readyTimer?.cancel();

    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_controller!.value.isTakingPicture) return;

    if (_controller!.value.isStreamingImages) {
      await _controller!.stopImageStream();
    }

    if (cubit.state.imagePaths.length >= 2) {
      _resetCaptureFlags();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AppAlertDialog(
          title: "Notification",
          errors: const ['Maximum 2 images allowed'],
          onConfirm: () => context.pop(),
        ),
      );
      return;
    }

    try {
      final file = await _controller!.takePicture();
      final image = img.decodeImage(await file.readAsBytes());

      if (image == null) {
        throw Exception('Cannot decode image');
      }

      final targetRatio = _isLandscape ? 0.62 : 1.35;

      final imgW = image.width;
      final imgH = image.height;

      int cropX;
      int cropY;
      int cropW;
      int cropH;

      if (imgH / imgW > targetRatio) {
        cropW = imgW;
        cropH = (imgW * targetRatio).toInt();
        cropX = 0;
        cropY = (imgH - cropH) ~/ 2;
      } else {
        cropH = imgH;
        cropW = (imgH / targetRatio).toInt();
        cropX = (imgW - cropW) ~/ 2;
        cropY = 0;
      }

      final extraLeftRight = (cropW * 0.085).toInt();
      final extraTop = (cropH * 0.085).toInt();
      final extraBottom = (cropH * 0.235).toInt();

      final newCropW = cropW - extraLeftRight * 2;
      final newCropH = cropH - extraTop - extraBottom;

      final newCropX = cropX + extraLeftRight;
      final newCropY = cropY + extraTop;

      final safeX = newCropX.clamp(0, imgW - newCropW);
      final safeY = newCropY.clamp(0, imgH - newCropH);
      final safeW = newCropW.clamp(1, imgW - safeX);
      final safeH = newCropH.clamp(1, imgH - safeY);

      final cropped = img.copyCrop(
        image,
        x: safeX,
        y: safeY,
        width: safeW,
        height: safeH,
      );

      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      File(path).writeAsBytesSync(img.encodeJpg(cropped, quality: 95));

      if (!mounted) return;

      if (!File(path).existsSync()) {
        await _resumeCameraAfterBack();
        return;
      }

      final beforeCount = cubit.state.imagePaths.length;

      cubit.confirmEdit(path);

      final result = await context.goToScanEdit<bool>(cubit);

      if (!mounted) return;

      if (result != true && cubit.state.imagePaths.length > beforeCount) {
        cubit.removeImage(cubit.state.imagePaths.length - 1);
      }

      await _resumeCameraAfterBack();
    } catch (e) {
      if (!mounted) return;

      await _resumeCameraAfterBack();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Capture failed: $e')));
    }
  }

  Future<void> _onPickFromGallery() async {
    _autoCaptureEnabled = false;
    _autoCheckTimer?.cancel();
    _readyTimer?.cancel();

    if (_controller != null &&
        _controller!.value.isInitialized &&
        _controller!.value.isStreamingImages) {
      await _controller!.stopImageStream();
    }

    final beforeCount = cubit.state.imagePaths.length;

    await cubit.pickFromGallery();

    if (!mounted) return;

    if (cubit.state.imagePaths.length > beforeCount) {
      final result = await context.goToScanReview<bool>(cubit);

      if (!mounted) return;

      if (result != true) {
        while (cubit.state.imagePaths.length > beforeCount) {
          cubit.removeImage(cubit.state.imagePaths.length - 1);
        }
      }

      await _resumeCameraAfterBack();
      return;
    }

    await _resumeCameraAfterBack();
  }

  Future<void> _resumeCameraAfterBack() async {
    _autoCheckTimer?.cancel();
    _readyTimer?.cancel();

    if (!mounted) return;

    setState(() {
      _hasCaptured = false;
      _isAutoCapturing = false;
      _isDetectingCard = false;
      _autoCaptureEnabled = true;
      _autoStatus = AutoCaptureStatus.checking;
    });

    if (_controller == null || !_controller!.value.isInitialized) {
      await _initCamera();
      return;
    }

    setState(() {
      _isReady = true;
    });

    _startAutoCapture();
  }

  void _resetCaptureFlags() {
    _hasCaptured = false;
    _isAutoCapturing = false;
    _isDetectingCard = false;
    _autoCaptureEnabled = true;
    _autoStatus = AutoCaptureStatus.checking;
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;

    final modes = [
      FlashMode.off,
      FlashMode.auto,
      FlashMode.always,
      FlashMode.torch,
    ];

    final next = modes[(_flashMode.index + 1) % modes.length];

    await _controller!.setFlashMode(next);

    if (!mounted) return;

    setState(() {
      _flashMode = next;
    });
  }

  IconData _flashIcon(FlashMode mode) {
    switch (mode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.torch:
        return Icons.flashlight_on;
    }
  }

  void _showCameraUnavailableDialog() {
    cubit.reset();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppAlertDialog(
        title: "Camera Unavailable",
        message: "Unable to access the camera. Please try again.",
        buttonLabel: "OK",
        icon: Icons.videocam_off_outlined,
        color: AppColor.error,
        onConfirm: () {
          Navigator.pop(context);
          context.goToHome();
        },
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _autoCheckTimer?.cancel();
      _readyTimer?.cancel();

      setState(() {
        _isReady = false;
      });

      cubit.releaseCamera();
      _controller = null;
      return;
    }

    if (state == AppLifecycleState.resumed) {
      if (_controller == null || !_controller!.value.isInitialized) {
        _initCamera();
      }
    }
  }

  @override
  void dispose() {
    _autoCheckTimer?.cancel();
    _readyTimer?.cancel();

    WidgetsBinding.instance.removeObserver(this);

    cubit.releaseCamera();
    _controller = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;

    final topPadding = height * 0.06;
    final sidePadding = width * 0.04;
    final bottomPadding = height * 0.06;
    final shutterSize = width * 0.18;
    final iconSize = width * 0.075;
    final zoomTop = height * 0.08;

    return Scaffold(
      backgroundColor: AppColor.black,
      body: BlocListener<ScanCubit, ScanState>(
        listenWhen: (_, current) =>
            current.status == ScanStatus.validationFailed,
        listener: (context, state) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AppAlertDialog(
              title: "Notification",
              errors: [state.errorMessage ?? 'Invalid file'],
              onConfirm: () {
                cubit.reset();
                Navigator.pop(context);
              },
            ),
          );
        },
        child: Stack(
          children: [
            GestureDetector(
              onScaleStart: (_) {
                _baseZoom = _currentZoom;
              },
              onScaleUpdate: (details) async {
                if (_controller == null || !_controller!.value.isInitialized) {
                  return;
                }

                final zoom = (_baseZoom * details.scale).clamp(
                  _minZoom,
                  _maxZoom,
                );

                if ((zoom - _lastAppliedZoom).abs() < 0.05) return;

                _currentZoom = zoom;
                _lastAppliedZoom = zoom;

                await _controller!.setZoomLevel(zoom);

                if (mounted) setState(() {});
              },
              child: SizedBox.expand(
                child: _controller != null
                    ? CameraPreview(_controller!)
                    : const Center(child: Text("No camera")),
              ),
            ),

            IgnorePointer(
              child: CameraOverlay(
                isLandscape: _isLandscape,
                status: _autoStatus,
              ),
            ),

            Positioned(
              top: topPadding,
              left: sidePadding,
              child: IconButton(
                onPressed: () {
                  _autoCheckTimer?.cancel();
                  _readyTimer?.cancel();

                  cubit.releaseCamera();
                  cubit.reset();

                  context.goToHome();
                },
                icon: Icon(Icons.close, color: AppColor.white, size: iconSize),
              ),
            ),

            Positioned(
              top: topPadding,
              right: sidePadding,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _isLandscape = !_isLandscape;
                  });
                },
                icon: Icon(
                  _isLandscape ? Icons.sync_alt : Icons.sync,
                  color: AppColor.white,
                  size: iconSize,
                ),
              ),
            ),

            Positioned(
              top: zoomTop,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.035,
                    vertical: height * 0.007,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(width * 0.05),
                  ),
                  child: Text(
                    "${_currentZoom.toStringAsFixed(1)}x",
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: bottomPadding,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _toggleFlash,
                    icon: Icon(
                      _flashIcon(_flashMode),
                      color: AppColor.white,
                      size: iconSize,
                    ),
                  ),

                  GestureDetector(
                    onTap: () async {
                      if (_hasCaptured) return;

                      _hasCaptured = true;
                      _isAutoCapturing = true;
                      _autoCaptureEnabled = false;

                      _autoCheckTimer?.cancel();
                      _readyTimer?.cancel();

                      if (_controller != null &&
                          _controller!.value.isInitialized &&
                          _controller!.value.isStreamingImages) {
                        await _controller!.stopImageStream();
                      }

                      await _takePicture();
                    },
                    child: Container(
                      width: shutterSize,
                      height: shutterSize,
                      decoration: const BoxDecoration(
                        color: AppColor.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: AppColor.black,
                        size: shutterSize * 0.5,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: _onPickFromGallery,
                    icon: Icon(
                      Icons.photo_library,
                      color: AppColor.white,
                      size: iconSize,
                    ),
                  ),
                ],
              ).paddingHorizontal(width * 0.05),
            ),
          ],
        ),
      ),
    );
  }
}
