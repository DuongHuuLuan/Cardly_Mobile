import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/utils/widget_pop_scope.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/presentation/scan/crop_editor/crop_editor_cubit.dart';
import 'package:cardly_app/presentation/scan/crop_editor/crop_editor_state.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_edit/crop_editor/widgets/bottom_actions.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_edit/crop_editor/widgets/image_viewport.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_edit/crop_editor/widgets/mode_toggle_bar.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_edit/crop_editor/widgets/rotation_slider.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_edit/crop_editor/widgets/tool_belt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CropEditorView extends StatelessWidget {
  final ValueChanged<String>? onConfirmed;
  final VoidCallback? onCanceled;

  const CropEditorView({super.key, this.onConfirmed, this.onCanceled});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black87,
      appBar: AppAppBar(
        title: "Edit Image",
        titleStyle: AppTextStyles.heading3.copyWith(color: AppColor.white),
        backgroundColor: AppColor.black87,
        leadingType: AppBarLeading.close,
        onLeadingPressed: () => _onCancel(context),
        centerTitle: true,
        iconLeadingColor: AppColor.white,
      ),
      body: Column(
        children: [
          Expanded(
            child:
                BlocSelector<CropEditorCubit, CropEditorState, CropEditorMode>(
                  selector: (s) => s.mode,
                  builder: (context, mode) =>
                      ImageViewport(cubit: context.read<CropEditorCubit>()),
                ).paddingHorizontal(16),
          ),
          ModeToggleBar(
            currentMode: context.select((CropEditorCubit c) => c.state.mode),
            onChanged: (mode) => context.read<CropEditorCubit>().setMode(mode),
          ),
          RotationSlider(
            value: context.select(
              (CropEditorCubit c) => c.state.rotationDegrees,
            ),
            onChanged: (v) => context.read<CropEditorCubit>().setRotation(v),
          ),
          ToolBelt(
            canUndo: context.select((CropEditorCubit c) => c.state.canUndo),
            canRedo: context.select((CropEditorCubit c) => c.state.canRedo),
            onUndo: () => context.read<CropEditorCubit>().undo(),
            onRedo: () => context.read<CropEditorCubit>().redo(),
            onReset: () => context.read<CropEditorCubit>().reset(),
          ),
          BottomActions(
            onCancel: () => _onCancel(context),
            onConfirm: () => _onConfirm(context),
            isLoading: context.select(
              (CropEditorCubit c) => c.state.isProcessing,
            ),
          ),
        ],
      ),
    ).canPop(false);
  }

  void _onCancel(BuildContext context) {
    onCanceled?.call();
    if (onCanceled == null) {
      Navigator.maybePop(context);
    }
  }

  Future<void> _onConfirm(BuildContext context) async {
    final cubit = context.read<CropEditorCubit>();
    try {
      final path = await cubit.processImage();
      if (!context.mounted) return;
      onConfirmed?.call(path);
      if (onConfirmed == null) {
        Navigator.maybePop(context, path);
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Processing failed: $e')));
    }
  }
}
