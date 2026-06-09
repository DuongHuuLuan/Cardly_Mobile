import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool border;

  final bool showAsGroup;
  final Color? groupBackground;
  final double? groupRadius;
  final EdgeInsetsGeometry? groupPadding;
  final TextStyle? groupLabelStyle;
  final TextStyle? groupInputStyle;

  const AppTextFormField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.border = true,
    this.showAsGroup = false,
    this.groupBackground,
    this.groupRadius,
    this.groupPadding,
    this.groupLabelStyle,
    this.groupInputStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (showAsGroup) return _buildGroup(context);
    return _buildDefault();
  }

  Widget _buildDefault() {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
        border: border
            ? OutlineInputBorder(borderRadius: BorderRadius.circular(12))
            : InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  /// Container + label
  Widget _buildGroup(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: groupPadding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: groupBackground ?? AppColor.white,
        borderRadius: BorderRadius.circular(groupRadius ?? 12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (labelText != null)
            Text(
              labelText!,
              style:
                  groupLabelStyle ??
                  AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.grey,
                  ),
            ),
          if (labelText != null) const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            validator: validator,
            style: groupInputStyle ?? AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColor.grey,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
