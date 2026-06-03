import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_alert_dialog.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_state.dart';
import 'package:flutter/material.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitialView extends StatelessWidget {
  final ScanCubit cubit;
  const InitialView({super.key, required this.cubit});
  @override
  Widget build(BuildContext context) {
    return BlocListener<ScanCubit, ScanState>(
      listenWhen: (previous, current) =>
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
      child: _CameraGalleryView(cubit: cubit),
    );
  }
}

class _CameraGalleryView extends StatelessWidget {
  final ScanCubit cubit;
  const _CameraGalleryView({required this.cubit});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColor.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 64,
              color: AppColor.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Take a photo or choose from your gallery",
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => cubit.pickFromCamera(),
              icon: const Icon(Icons.camera_alt),
              label: const Text("Open Camera"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => cubit.pickFromGallery(),
              icon: const Icon(Icons.photo_library),
              label: const Text("Choose from Gallery"),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColor.black87,
                side: const BorderSide(
                  color: AppColor.greyDark,
                  strokeAlign: 3,
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              cubit.reset();
              context.goToHome();
            },
            child: const Text(
              "Back to home",
              style: TextStyle(color: AppColor.grey),
            ),
          ),
        ],
      ).paddingAll(32),
    );
  }
}
