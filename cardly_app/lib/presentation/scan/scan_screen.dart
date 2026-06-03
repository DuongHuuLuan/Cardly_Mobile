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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<ScanCubit>();
      cubit.reset();
      cubit.pickFromCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          context.select((ScanCubit c) => c.state.status) == ScanStatus.initial
          ? null
          : AppAppBar(
              title: "OCR Scanning",
              onLeadingPressed: () => context.goToHome(),
            ),
      body: BlocListener<ScanCubit, ScanState>(
        listenWhen: (prev, current) =>
            prev.status == ScanStatus.initial &&
            current.status == ScanStatus.imageSelected,
        listener: (context, state) {
          final cubit = context.read<ScanCubit>();
          if (state.imageSource == ImageSourceType.camera) {
            context.goToScanCamera(cubit);
          } else {
            context.goToScanPreview(cubit);
          }
        },
        child: BlocBuilder<ScanCubit, ScanState>(
          builder: (context, state) {
            if (state.status == ScanStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            return InitialView(cubit: context.read<ScanCubit>());
          },
        ),
      ),
    );
  }
}
