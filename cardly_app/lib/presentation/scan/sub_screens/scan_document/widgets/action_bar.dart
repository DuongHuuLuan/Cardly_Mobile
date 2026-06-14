import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
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
        AppElevatedButton(
          label: "Enriching AI information",
          onPressed: isEnriching ? null : onEnrich,
          icon: const Icon(Icons.auto_awesome_outlined, size: 20),
          isLoading: isEnriching,
          backgroundColor: AppColor.white,
          borderColor: AppColor.primary.withValues(alpha: 0.2),
          labelColor: AppColor.primary,
          iconColor: AppColor.primary,
          height: MediaQuery.of(context).size.height * 0.06,
        ),
        const SizedBox(height: 12),
        AppElevatedButton(
          label: "Save contact",
          onPressed: isSaving ? null : onSave,
          backgroundColor: AppColor.primary,
          labelColor: AppColor.white,
          icon: const Icon(Icons.save_outlined, size: 20),
          iconColor: AppColor.white,
          isLoading: isSaving,
          height: MediaQuery.of(context).size.height * 0.06,
        ),
      ],
    );
  }
}
