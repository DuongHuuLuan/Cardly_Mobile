import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_alert_dialog.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_state.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_preview/widgets/preview_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ScanCubit>();
    return MultiBlocListener(
      listeners: [
        BlocListener<ScanCubit, ScanState>(
          listenWhen: (prev, current) =>
              current.status == ScanStatus.validationFailed,
          listener: (context, state) => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AppAlertDialog(
              title: "Notification",
              errors: [state.errorMessage ?? 'Invalid file'],
              onConfirm: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        BlocListener<ScanCubit, ScanState>(
          listenWhen: (prev, current) => current.status == ScanStatus.uploading,
          listener: (context, state) =>
              context.go('/scan/upload', extra: cubit),
        ),
      ],
      child: BlocBuilder<ScanCubit, ScanState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Review', style: AppTextStyles.heading3),
              centerTitle: true,
            ),
            body: PreviewView(
              imagePaths: state.imagePaths,
              onCamera: () => context.go('/scan/custom-camera', extra: cubit),
              onGallery: () => cubit.pickFromGallery(),
              onConfirm: () => cubit.uploadAndScan(),
              onRemove: cubit.removeImage,
              canAddMore: state.imagePaths.length < 2,
            ),
          );
        },
      ),
    );
  }
}
