import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:flutter/material.dart';

class ActionBar extends StatelessWidget {
  final VoidCallback? onEnrich;
  final VoidCallback? onSave;
  final bool isEnriching;
  final bool isSaving;
  const ActionBar({
    super.key,
    this.onEnrich,
    this.onSave,
    this.isEnriching = false,
    this.isSaving = false,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColor.primary,
              side: const BorderSide(color: AppColor.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: isEnriching ? null : onEnrich,
            icon: isEnriching
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome_outlined, size: 20),
            label: Text(
              isEnriching ? "Getting rich..." : "Enriching AI information",
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: AppColor.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            onPressed: isSaving ? null : onSave,
            icon: isSaving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor.white,
                    ),
                  )
                : Icon(Icons.save_outlined, size: 20),

            label: Text(
              isSaving ? "Saving..." : "Save contact",
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColor.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
