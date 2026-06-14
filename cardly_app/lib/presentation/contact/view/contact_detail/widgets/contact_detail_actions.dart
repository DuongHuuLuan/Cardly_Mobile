import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_alert_dialog.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:flutter/material.dart';

class ContactDetailActions extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  const ContactDetailActions({
    super.key,
    required this.isEditing,
    required this.onSave,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppElevatedButton(
      label: isEditing ? "Save Edit" : "Delete Contact",
      onPressed: isEditing ? onSave : () => _confirmDelete(context),
      backgroundColor: isEditing ? AppColor.primary : AppColor.background,
      borderColor: isEditing ? null : AppColor.error.withValues(alpha: 0.5),
      labelColor: isEditing ? AppColor.white : AppColor.error,
      iconAfterText: false,
      icon: Icon(
        isEditing ? Icons.save_outlined : Icons.delete_outline,
        color: isEditing ? AppColor.white : AppColor.error,
        size: 24,
      ),
    ).paddingAll(20);
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AppAlertDialog(
        title: "Delete contact",
        message: "Are you sure?",
        onCancel: () => Navigator.pop(ctx),
        cancelLabel: "Cancel",
        buttonLabel: "Delete",
        buttonLabelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColor.white,
        ),
        onConfirm: () {
          Navigator.pop(ctx);
          onDelete();
        },
      ),
    );
  }
}
