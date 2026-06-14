import 'package:cardly_app/core/cubit/loading/app_loading_cubit.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/presentation/scan/widgets/initial_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_state.dart';

class ScanScreen extends StatefulWidget {
  static const routerName = "/scan";

  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loadingCubit = context.read<AppLoadingCubit>();
      final scanCubit = context.read<ScanCubit>();

      loadingCubit.show();

      scanCubit.reset();
      scanCubit.pickFromCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScanCubit, ScanState>(
      listenWhen: (prev, current) => prev.status != current.status,
      listener: (context, state) {
        final loadingCubit = context.read<AppLoadingCubit>();
        final scanCubit = context.read<ScanCubit>();

        if (state.status == ScanStatus.initial) {
          loadingCubit.show();
        } else {
          loadingCubit.hide();
        }

        if (state.status == ScanStatus.imageSelected) {
          if (state.imageSource == ImageSourceType.camera) {
            context.goToScanCamera(scanCubit);
          } else {
            context.goToScanReview(scanCubit);
          }
        }
      },
      child: Scaffold(
        appBar:
            context.select((ScanCubit c) => c.state.status) ==
                ScanStatus.initial
            ? null
            : AppAppBar(
                title: "OCR Scanning",
                onLeadingPressed: () => context.goToHome(),
              ),
        body: BlocBuilder<ScanCubit, ScanState>(
          builder: (context, state) {
            return InitialView(cubit: context.read<ScanCubit>());
          },
        ),
      ),
    );
  }
}
