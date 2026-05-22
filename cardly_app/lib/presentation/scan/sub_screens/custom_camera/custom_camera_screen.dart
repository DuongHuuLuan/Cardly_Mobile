import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cardly_app/core/widgets/app_alert_dialog.dart';
import 'package:cardly_app/presentation/scan/sub_screens/custom_camera/widgets/camera_overlay.dart';
import 'package:flutter/material.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:cardly_app/domain/enums/document_type.dart';
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
  List<CameraDescription>? _cameras;
  bool _isReady = false;
  @override
  void initState() {
    super.initState();
    cubit = context.read<ScanCubit>();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    final controller = CameraController(cameras.first, ResolutionPreset.high);
    await controller.initialize();
    if (!mounted) return;
    setState(() {
      _cameras = cameras;
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

      final docType = cubit.state.documentType;
      final isLandscape =
          docType == DocumentType.driverLicence ||
          docType == DocumentType.medicareCard;

      final targetRatio = isLandscape ? 0.62 : 1.35;

      final imgW = image.width;
      final imgH = image.height;

      int cropX, cropY, cropW, cropH;

      // Tính crop theo tỷ lệ chuẩn trước
      if (imgH / imgW > targetRatio) {
        // Ảnh quá dài → crop chiều cao
        cropW = imgW;
        cropH = (imgW * targetRatio).toInt();
        cropX = 0;
        cropY = (imgH - cropH) ~/ 2;
      } else {
        // Ảnh quá rộng → crop chiều rộng
        cropH = imgH;
        cropW = (imgH / targetRatio).toInt();
        cropX = (imgW - cropW) ~/ 2;
        cropY = 0;
      }

      // ==================== CROP THÊM (TĂNG ĐỘ CHẶT) ====================
      final double marginPercent = 0.085; // crop đều 2 bên + trên
      final double bottomExtraPercent =
          0.15; // crop thêm ở bottom (tăng số này nếu muốn cắt dưới nhiều hơn)

      final int extraLeftRight = (cropW * marginPercent).toInt();
      final int extraTop = (cropH * marginPercent).toInt();
      final int extraBottom = (cropH * (marginPercent + bottomExtraPercent))
          .toInt();

      final int newCropW = cropW - extraLeftRight * 2;
      final int newCropH = cropH - extraTop - extraBottom;

      final int newCropX = cropX + extraLeftRight;
      final int newCropY = cropY + extraTop;
      // =================================================================

      // Kiểm tra an toàn để không crop ra ngoài ảnh
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

  void _flipCamera() {
    if (_cameras == null || _cameras!.length < 2) return;
    final idx = _cameras!.indexOf(_controller!.description);
    final newIdx = idx == 0 ? 1 : 0;
    _controller = CameraController(_cameras![newIdx], ResolutionPreset.high);
    _controller!.initialize().then((_) {
      if (mounted) setState(() {});
    });
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
    final docType = context.read<ScanCubit>().state.documentType;
    final isLandscape =
        docType == DocumentType.driverLicence ||
        docType == DocumentType.medicareCard;
    if (!_isReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Colors.black,
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
          // Overlay frame
          IgnorePointer(child: CameraOverlay(isLandscape: isLandscape)),

          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close, color: Colors.white, size: 32),
                ),
                GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                      size: 36,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _flipCamera,
                  icon: const Icon(
                    Icons.flip_camera_android,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
