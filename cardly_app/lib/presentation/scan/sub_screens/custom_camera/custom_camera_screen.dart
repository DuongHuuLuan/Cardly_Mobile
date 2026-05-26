import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/widgets/app_alert_dialog.dart';
import 'package:cardly_app/presentation/scan/sub_screens/custom_camera/widgets/camera_overlay.dart';
import 'package:flutter/material.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class CustomCameraScreen extends StatefulWidget {
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
  @override
  void initState() {
    super.initState();
    cubit = context.read<ScanCubit>();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final controller = CameraController(cameras.first, ResolutionPreset.high);
    await controller.initialize();
    if (!mounted) return;
    setState(() {
      _controller = controller;
      _isReady = true;
    });
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
      context.go('/scan/edit', extra: cubit);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Capture failed: $e')));
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (state == AppLifecycleState.resumed) {
      _controller!.resumePreview();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: AppColor.black,
      body: Stack(
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

          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColor.white,
                      size: 35,
                    ),
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
                    icon: Icon(
                      _isLandscape ? Icons.sync_alt : Icons.sync,
                      color: AppColor.white,
                      size: 28,
                    ),
                    tooltip: _isLandscape
                        ? 'Switch to portrait'
                        : 'Switch to landscape',
                    onPressed: () =>
                        setState(() => _isLandscape = !_isLandscape),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
