import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final bool isEditing;
  final ValueChanged<String>? onChanged;
  const InfoRow({
    super.key,
    required this.label,
    this.value,
    this.isEditing = false,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColor.greyDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: isEditing
              ? TextFormField(
                  initialValue: value,
                  onChanged: onChanged,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.black87,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    border: OutlineInputBorder(),
                  ),
                )
              : Text(
                  (value ?? '').isEmpty ? '-' : value!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.black87,
                  ),
                ),
        ),
      ],
    ).paddingVertical(6);
  }
}
