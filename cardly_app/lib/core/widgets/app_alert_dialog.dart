import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String? message;
  final List<String>? errors;
  final String buttonLabel;
  final VoidCallback onConfirm;
  final IconData icon;
  final Color color;

  const AppAlertDialog({
    super.key,
    required this.title,
    this.message,
    this.errors,
    required this.onConfirm,
    this.buttonLabel = "Retry",
    this.icon = Icons.error_outline,
    this.color = AppColor.error,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.heading3.copyWith(color: color),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            if (message != null)
              Text(
                message!,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),

            if (errors != null && errors!.isNotEmpty)
              ...errors!.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.cancel, color: color, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          e,
                          style: TextStyle(color: color.withValues(alpha: 0.8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
