import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:flutter/material.dart';

class DocumentFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final IconData? icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool readOnly;

  const DocumentFormField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label.toUpperCase(),
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColor.grey,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColor.greyLight, width: 1.2),
              ),
            ),
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              maxLines: maxLines,
              keyboardType: keyboardType,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColor.black87),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColor.grey,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 4,
                ),
                prefixIcon: icon != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(icon, color: AppColor.greyDark, size: 22),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
