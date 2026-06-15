import 'package:flutter/material.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';

class ValidationFailedView extends StatelessWidget {
  final List<String> errors;
  final VoidCallback onRetry;

  const ValidationFailedView({
    super.key,
    required this.errors,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColor.error),
          const SizedBox(height: 16),
          const Text(
            "Image does not meet requirements",
            style: AppTextStyles.heading3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ...errors.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.cancel, color: AppColor.error, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      e,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColor.error),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          AppElevatedButton(
            label: "Choose another photo",
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ).paddingAll(32),
    );
  }
}
