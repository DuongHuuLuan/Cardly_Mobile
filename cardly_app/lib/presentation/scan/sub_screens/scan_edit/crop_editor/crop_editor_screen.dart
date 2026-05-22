import 'package:cardly_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'crop_editor_controller.dart';
import 'widgets/image_viewport.dart';
import 'widgets/rotation_slider.dart';
import 'widgets/aspect_ratio_bar.dart';
import 'widgets/mode_toggle_bar.dart';
import 'widgets/tool_belt.dart';
import 'widgets/bottom_actions.dart';

class CropEditorScreen extends StatefulWidget {
  final String imagePath;

  const CropEditorScreen({super.key, required this.imagePath});

  @override
  State<CropEditorScreen> createState() => _CropEditorScreenState();
}

class _CropEditorScreenState extends State<CropEditorScreen> {
  late final CropEditorController _controller;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = CropEditorController();
    _controller.initFromFile(widget.imagePath);
    _controller.addListener(_onControllerChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChange() {
    if (mounted) setState(() {});
  }

  Future<void> _onConfirm() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      final outputPath = await _controller.processImage();
      if (!mounted) return;
      final cubit = context.read<ScanCubit>();
      cubit.confirmEdit(outputPath);
      context.go('/scan/review', extra: cubit);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Processing failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _onCancel() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black87,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.white),
          onPressed: _onCancel,
        ),
        title: Text('Edit Image', style: TextStyle(color: AppColor.white)),
        centerTitle: true,
        backgroundColor: AppColor.black87,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(child: ImageViewport(controller: _controller)),
          ModeToggleBar(
            currentMode: _controller.mode,
            onChanged: _controller.setMode,
          ),
          RotationSlider(
            value: _controller.rotationDegrees,
            onChanged: _controller.setRotation,
          ),
          ToolBelt(
            canUndo: _controller.canUndo,
            canRedo: _controller.canRedo,
            onUndo: _controller.undo,
            onRedo: _controller.redo,
            onReset: _controller.reset,
          ),
          AspectRatioBar(
            selected: _controller.selectedRatio,
            onChanged: _controller.setAspectRatio,
          ),
          BottomActions(
            onCancel: _onCancel,
            onConfirm: _onConfirm,
            isLoading: _isProcessing,
          ),
        ],
      ),
    );
  }
}
