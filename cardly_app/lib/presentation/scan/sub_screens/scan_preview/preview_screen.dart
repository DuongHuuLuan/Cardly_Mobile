import 'dart:io';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';

class PreviewScreen extends StatefulWidget {
  static const routerName = "scan-preview";

  const PreviewScreen({super.key});
  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late final ScanCubit cubit;
  late PageController _pageController;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    cubit = context.read<ScanCubit>();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagePaths = cubit.state.imagePaths;
    return Scaffold(
      appBar: AppAppBar(
        titleWidget: Text(
          imagePaths.length > 1
              ? 'Preview (${_currentIndex + 1}/${imagePaths.length})'
              : 'Preview',
          style: AppTextStyles.heading3,
        ),
        leadingType: AppBarLeading.close,
        onLeadingPressed: () => context.push("/scan", extra: cubit),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemCount: imagePaths.length,
              itemBuilder: (context, index) => InteractiveViewer(
                child: Center(
                  child: Image.file(
                    File(imagePaths[index]),
                    key: ValueKey(imagePaths[index]),
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          ),
          if (imagePaths.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imagePaths.length,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == i
                        ? AppColor.primary
                        : AppColor.greyLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ).paddingVertical(12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    cubit.reset();
                    cubit.pickFromGallery();
                  },
                  icon: Icon(Icons.photo_library),
                  label: Text("Select again", style: AppTextStyles.bodyLarge),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColor.primary,
                    side: const BorderSide(color: AppColor.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppElevatedButton(
                  label: 'Continue',
                  labelStyle: AppTextStyles.bodyLarge.copyWith(
                    color: AppColor.white,
                  ),
                  iconAfterText: true,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColor.white,
                    size: 20,
                  ),
                  onPressed: () => context.goToScanReview(cubit),
                ),
              ),
            ],
          ).paddingOnly(left: 24, right: 24, bottom: 24),
        ],
      ),
    );
  }
}
