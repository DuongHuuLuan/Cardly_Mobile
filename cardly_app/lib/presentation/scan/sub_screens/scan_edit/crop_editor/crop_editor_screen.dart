import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/widget_pop_scope.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'crop_editor_controller.dart';
import 'widgets/image_viewport.dart';
import 'widgets/rotation_slider.dart';
import 'widgets/mode_toggle_bar.dart';
import 'widgets/tool_belt.dart';
import 'widgets/bottom_actions.dart';

class CropEditorScreen extends StatefulWidget {
  final String imagePath;
  final ValueChanged<String>? onConfirmed;
  final VoidCallback? onCanceled;

  const CropEditorScreen({
    super.key,
    required this.imagePath,
    this.onConfirmed,
    this.onCanceled,
  });

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
    _isProcessing = true;
    if (mounted) setState(() {});

    try {
      final dir = await getTemporaryDirectory();
      final outPath =
          '${dir.path}/edit_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final resultPath = await _controller.processImage(outputPath: outPath);

      if (!mounted) return;
      if (widget.onConfirmed != null) {
        widget.onConfirmed!(resultPath);
      } else {
        Navigator.pop(context, resultPath);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Processing failed: $e')));
    } finally {
      if (mounted) {
        _isProcessing = false;
        setState(() {});
      }
    }
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black87,
      appBar: AppAppBar(
        title: "Edit Image",
        titleStyle: AppTextStyles.heading3.copyWith(color: AppColor.white),
        backgroundColor: AppColor.black87,
        leadingType: AppBarLeading.close,
        onLeadingPressed: _onCancel,
        centerTitle: true,
        iconLeadingColor: AppColor.white,
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
          BottomActions(
            onCancel: _onCancel,
            onConfirm: _onConfirm,
            isLoading: _isProcessing,
          ),
        ],
      ),
    ).canPop(false);
  }
}
