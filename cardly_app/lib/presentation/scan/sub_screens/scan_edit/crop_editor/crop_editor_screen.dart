import 'package:cardly_app/presentation/scan/crop_editor/crop_editor_cubit.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_edit/crop_editor/widgets/crop_editor_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CropEditorCubit(widget.imagePath),
      child: CropEditorView(
        onConfirmed: widget.onConfirmed,
        onCanceled: widget.onCanceled,
      ),
    );
  }
}
