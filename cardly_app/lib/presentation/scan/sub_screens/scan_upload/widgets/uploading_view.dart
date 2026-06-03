import 'package:flutter/material.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_upload/widgets/upload_progress_circle.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_upload/widgets/upload_steps_card.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_upload/widgets/upload_security_footer.dart';

class UploadingView extends StatelessWidget {
  final double progress;
  final VoidCallback onCancel;

  const UploadingView({
    super.key,
    required this.progress,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final int percent = (progress * 100).toInt();

    return SafeArea(
      child: Column(
            children: [
            const SizedBox(height: 20),
            UploadProgressCircle(progress: progress),
            const SizedBox(height: 32),
            Text(
              "Processing Document",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "We are securely uploading and verifying\nyour document for OCR processing.",
              style: TextStyle(fontSize: 16, color: AppColor.grey, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            UploadStepsCard(percent: percent),
            const Spacer(),
            UploadSecurityFooter(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColor.greyLight, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  "Cancel Upload",
                  style: TextStyle(
                    color: AppColor.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, size: 14, color: AppColor.grey),
                const SizedBox(width: 4),
                Text(
                  "Duplicate submissions are automatically blocked",
                  style: TextStyle(color: AppColor.grey, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        )
            .paddingHorizontal(24)
            .paddingVertical(16),
    );
  }
}
