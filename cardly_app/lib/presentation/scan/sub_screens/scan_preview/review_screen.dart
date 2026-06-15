import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/utils/permission_utils.dart';
import 'package:cardly_app/core/widgets/app_alert_dialog.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_state.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_preview/widgets/preview_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewScreen extends StatelessWidget {
  static const routerName = "scan-review";

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
          listener: (context, state) => context.goToScanUpload(cubit),
        ),
      ],
      child: BlocBuilder<ScanCubit, ScanState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppAppBar(
              title: 'Review',
              centerTitle: true,
              leadingType: AppBarLeading.close,
              onLeadingPressed: () => context.goToHome(),
            ),
            body: PreviewView(
              imagePaths: state.imagePaths,
              onCamera: () => context.goToScanCamera(cubit),
              onGallery: () async {
                final granted = await requestGalleryPermission(context);
                if (granted) cubit.pickFromGallery();
              },
              onConfirm: () => cubit.uploadAndScan(),
              onRemove: cubit.removeImage,
              canAddMore: state.imagePaths.length < 2,
              onReplaceImage: (index, newPath) {
                context.read<ScanCubit>().replaceImage(index, newPath);
              },
            ),
          );
        },
      ),
    );
  }
}
