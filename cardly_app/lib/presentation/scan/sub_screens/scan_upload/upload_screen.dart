import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/presentation/home/view/home_screen.dart';
import 'package:cardly_app/presentation/scan/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_state.dart';
import 'package:cardly_app/presentation/scan/widgets/error_view.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_upload/widgets/uploading_view.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ScanCubit>();

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) cubit.reset();
      },
      child: BlocListener<ScanCubit, ScanState>(
        listenWhen: (previous, current) =>
            current.status == ScanStatus.success &&
            previous.status != current.status,
        listener: (context, state) {
          context.go("/scan/upload-success", extra: cubit);
        },

        child: Scaffold(
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
                    onRetry: () {
                      context.goToHome();
                    },
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
