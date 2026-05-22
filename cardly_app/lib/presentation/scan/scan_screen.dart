import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/presentation/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_state.dart';
import 'package:cardly_app/presentation/scan/widgets/initial_view.dart';

extension ScanNavigation on BuildContext {
  void goToScan() => go('/scan');
}

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ScanCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text("OCR Scanning", style: AppTextStyles.heading3),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.goToHome(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: BlocListener<ScanCubit, ScanState>(
        listenWhen: (prev, current) =>
            prev.status == ScanStatus.initial &&
            current.status == ScanStatus.imageSelected,
        listener: (context, state) {
          if (state.imageSource == ImageSourceType.camera) {
            context.push('/scan/custom-camera', extra: cubit);
          } else {
            context.push('/scan/preview', extra: cubit);
          }
        },
        child: BlocBuilder<ScanCubit, ScanState>(
          builder: (context, state) {
            return InitialView(cubit: cubit);
          },
        ),
      ),
    );
  }
}
