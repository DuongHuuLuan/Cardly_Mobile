import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/widgets/app_alert_dialog.dart'; // THÊM
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_state.dart';
import 'package:cardly_app/presentation/scan/widgets/error_view.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_upload/widgets/uploading_view.dart';

class UploadScreen extends StatelessWidget {
  static const routerName = "scan-upload";

  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ScanCubit>();

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) cubit.reset();
      },
      child: Stack(
        children: [
          BlocListener<ScanCubit, ScanState>(
            listenWhen: (previous, current) =>
                current.status == ScanStatus.success &&
                previous.status != current.status,
            listener: (context, state) {
              context.goToScanUploadSuccess(cubit);
            },
            child: const SizedBox.shrink(),
          ),
          BlocListener<ScanCubit, ScanState>(
            listenWhen: (previous, current) =>
                current.status == ScanStatus.failure &&
                previous.status != current.status,
            listener: (context, state) {
              final msg = _userFriendlyMessage(
                state.errorMessage ?? "An error occurred",
              );
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => AppAlertDialog(
                  title: "Upload Failed",
                  message: msg,
                  buttonLabel: "OK",
                  icon: Icons.error_outline,
                  color: AppColor.error,
                  onConfirm: () {
                    Navigator.pop(ctx);
                    cubit.reset();
                    context.goToScan();
                  },
                ),
              );
            },
            child: const SizedBox.shrink(),
          ),

          Scaffold(
            appBar: AppAppBar(
              elevation: 0,
              title: "Uploading",
              onLeadingPressed: () {
                cubit.reset();
                context.goToScan();
              },
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.help_outline,
                    color: AppColor.grey,
                    size: 22,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            body: BlocBuilder<ScanCubit, ScanState>(
              builder: (context, state) {
                switch (state.status) {
                  case ScanStatus.uploading:
                    return UploadingView(
                      progress: state.uploadProgress,
                      onCancel: () {
                        cubit.reset();
                        context.pop();
                      },
                    );
                  case ScanStatus.success:
                    return const SizedBox.shrink();
                  case ScanStatus.failure:
                    return ErrorView(
                      message: state.errorMessage ?? "Failed to scan",
                      onRetry: () => context.goToHome(),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _userFriendlyMessage(String raw) {
    if (raw.contains('already been uploaded')) {
      return 'This file has already been scanned. Please take a new photo.';
    }
    if (raw.contains('timeout')) {
      return 'The scan is taking longer than expected. Please try again.';
    }
    if (raw.contains('Network error') || raw.contains('Connection')) {
      return 'Unable to connect to the server. Please check your internet connection and try again.';
    }
    if (raw.contains('422') || raw.contains('Invalid')) {
      return 'The image could not be processed. Please try with a different image.';
    }
    if (raw.contains('401') ||
        raw.contains('Unauthorized') ||
        raw.contains('token')) {
      return 'Your session has expired. Please login again.';
    }
    // Fallback
    return raw;
  }
}
