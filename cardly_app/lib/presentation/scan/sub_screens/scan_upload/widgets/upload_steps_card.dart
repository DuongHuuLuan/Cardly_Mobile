import 'package:flutter/material.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/presentation/scan/widgets/step_row.dart';

class UploadStepsCard extends StatelessWidget {
  final int percent;

  const UploadStepsCard({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    const step1Status = "Done";
    final step2Status = percent < 100 ? "In Progress" : "Done";
    final step3Status = percent < 100 ? "Pending" : "In Progress";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.greyLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          StepRow(
            icon: Icons.check_circle_outline,
            title: "Image quality check",
            status: step1Status,
          ),
          const Divider(height: 24, color: Colors.transparent),
          StepRow(
            icon: Icons.lens,
            title: "Uploading to secure server",
            status: step2Status,
            isDotIcon: true,
          ),
          const Divider(height: 24, color: Colors.transparent),
          StepRow(
            icon: Icons.lock_outline,
            title: "Extracting data fields",
            status: step3Status,
          ),
        ],
      ),
    );
  }
}
