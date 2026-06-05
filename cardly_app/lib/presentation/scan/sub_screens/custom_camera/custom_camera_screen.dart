import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_alert_dialog.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_state.dart';
import 'package:cardly_app/presentation/scan/sub_screens/custom_camera/widgets/camera_overlay.dart';
import 'package:flutter/material.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

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

  @override
  void initState() {
    super.initState();
    cubit = context.read<ScanCubit>();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final controller = await cubit.getCameraController();

      if (!mounted) return;
      setState(() {
        _controller = controller;
        _isReady = true;
      });
    } catch (e) {
      if (mounted) _showCameraUnavailableDialog();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      setState(() => _isReady = false);
      cubit.releaseCamera();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
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
    setState(() => _flashMode = next);
  }

  Future<void> _onPickFromGallery() async {
    await cubit.pickFromGallery();
    if (!mounted) return;
    if (cubit.state.imagePaths.isNotEmpty) {
      context.goToScanPreview(cubit);
    }
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

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (cubit.state.imagePaths.length >= 2) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AppAlertDialog(
          title: "Notification",
          errors: const ['Maximum 2 images allowed'],
          onConfirm: () {
            context.pop();
          },
        ),
      );
      return;
    }

    try {
      final file = await _controller!.takePicture();
      final image = img.decodeImage(await file.readAsBytes());
      if (image == null) throw Exception('Cannot decode image');

      final targetRatio = _isLandscape ? 0.62 : 1.35;

      final imgW = image.width;
      final imgH = image.height;

      int cropX, cropY, cropW, cropH;

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

      final double marginPercent = 0.085;
      final double bottomExtraPercent = 0.15;

      final int extraLeftRight = (cropW * marginPercent).toInt();
      final int extraTop = (cropH * marginPercent).toInt();
      final int extraBottom = (cropH * (marginPercent + bottomExtraPercent))
          .toInt();

      final int newCropW = cropW - extraLeftRight * 2;
      final int newCropH = cropH - extraTop - extraBottom;

      final int newCropX = cropX + extraLeftRight;
      final int newCropY = cropY + extraTop;

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

      // Lưu ảnh
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      File(path).writeAsBytesSync(img.encodeJpg(cropped, quality: 95));

      if (!mounted) return;

      if (!File(path).existsSync()) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to save image')));
        return;
      }

      cubit.confirmEdit(path);
      context.goToScanEdit(cubit);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Capture failed: $e')));
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cubit.releaseCamera();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: AppColor.black,
      body: BlocListener<ScanCubit, ScanState>(
        listenWhen: (_, current) =>
            current.status == ScanStatus.validationFailed,
        listener: (context, state) => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AppAlertDialog(
            title: "Notification",
            errors: [state.errorMessage ?? 'Invalid file'],
            onConfirm: () {
              cubit.reset();
              Navigator.pop(context);
            },
          ),
        ),
        child: Stack(
          children: [
            // Camera preview
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: _controller != null
                  ? CameraPreview(_controller!)
                  : const Center(child: Text("No camera")),
            ),
            IgnorePointer(child: CameraOverlay(isLandscape: _isLandscape)),

            //icon back
            Positioned(
              top: 48,
              left: 16,
              child: IconButton(
                onPressed: () {
                  cubit.releaseCamera();
                  context.pop();
                },
                icon: const Icon(Icons.close, color: AppColor.white, size: 30),
              ),
            ),

            // xoay khung camera
            Positioned(
              top: 48,
              right: 16,
              child: IconButton(
                onPressed: () => setState(() => _isLandscape = !_isLandscape),
                icon: Icon(
                  _isLandscape ? Icons.sync_alt : Icons.sync,
                  color: AppColor.white,
                  size: 28,
                ),
                tooltip: _isLandscape
                    ? 'Switch to portrait'
                    : 'Switch to landscape',
              ),
            ),

            // den flash
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _toggleFlash,
                    icon: Icon(
                      _flashIcon(_flashMode),
                      color: AppColor.white,
                      size: 30,
                    ),
                    tooltip: 'Flash',
                  ),
                  GestureDetector(
                    onTap: _takePicture,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: const BoxDecoration(
                        color: AppColor.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: AppColor.black,
                        size: 42,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _onPickFromGallery,
                    icon: const Icon(
                      Icons.photo_library,
                      color: AppColor.white,
                      size: 28,
                    ),
                    tooltip: 'Choose from gallery',
                  ),
                ],
              ).paddingHorizontal(20),
            ),
          ],
        ),
      ),
    );
  }
}
