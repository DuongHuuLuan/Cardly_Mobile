import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/utils/permission_utils.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_alert_dialog.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_state.dart';
import 'package:flutter/material.dart';
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
          AppElevatedButton(
            label: "Open Camera",
            onPressed: () => cubit.pickFromCamera(),
            icon: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final granted = await requestGalleryPermission(context);
                if (!context.mounted) return;
                if (granted) {
                  cubit.pickFromGallery();
                } else {
                  context.goToHome();
                }
              },
              icon: Icon(Icons.photo_library, color: AppColor.black87),
              label: Text(
                "Choose from Gallery",
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColor.black87,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColor.black87,
                side: const BorderSide(color: AppColor.greyDark),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              cubit.reset();
              context.goToHome();
            },
            child: Text(
              "Back to home",
              style: AppTextStyles.bodyMedium.copyWith(color: AppColor.grey),
            ),
          ),
        ],
      ).paddingAll(32),
    );
  }
}
