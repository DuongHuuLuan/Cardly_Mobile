import 'package:flutter/material.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';

class UploadProgressCircle extends StatelessWidget {
  final double progress;

  const UploadProgressCircle({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final int percent = (progress * 100).toInt();

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 4,
            backgroundColor: AppColor.greyLight.withValues(alpha: 0.5),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColor.primary),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_upload_outlined,
              size: 32,
              color: AppColor.primary,
            ),
            const SizedBox(height: 8),
            Text(
              "$percent%",
              style: AppTextStyles.heading3.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
