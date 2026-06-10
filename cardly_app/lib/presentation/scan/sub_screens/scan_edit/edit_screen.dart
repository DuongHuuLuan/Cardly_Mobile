import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'crop_editor/crop_editor_screen.dart';

class EditScreen extends StatelessWidget {
  static const routerName = "scan-camera-edit";

  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ScanCubit>();
    final imagePath = cubit.state.imagePaths.last;
    return CropEditorScreen(
      imagePath: imagePath,
      onConfirmed: (outputPath) {
        // cubit.confirmEdit(outputPath);
        cubit.replaceImage(cubit.state.imagePaths.length - 1, outputPath);
        File(imagePath).deleteSync();

        context.goToScanReview(cubit);
      },
      onCanceled: () {
        cubit.reset();
        context.goToScan();
      },
    );
  }
}
