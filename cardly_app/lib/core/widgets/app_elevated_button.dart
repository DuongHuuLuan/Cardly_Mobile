import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  final String label;
  final Color? labelColor;
  final TextStyle? labelStyle;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double? height;
  final bool isLoading;
  final Color? borderColor;

  final Widget? icon;
  final bool iconAfterText;
  final double iconSpacing;

  const AppElevatedButton({
    super.key,
    required this.label,
    this.labelStyle,
    this.labelColor,
    required this.onPressed,
    this.backgroundColor,
    this.height,
    this.isLoading = false,
    this.borderColor,
    this.icon,
    this.iconAfterText = false,
    this.iconSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColor.primary,
          disabledBackgroundColor:
              backgroundColor?.withValues(alpha: 0.6) ??
              AppColor.primary.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor ?? AppColor.primary),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColor.white,
                ),
              )
            : _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    final textWidget = Text(
      label,
      style:
          labelStyle ??
          AppTextStyles.bodyLarge.copyWith(
            color: labelColor ?? AppColor.primary,
          ),
    );

    if (icon == null) return textWidget;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // nếu iconAfterText == false thì hiển icon nằm phía trước
        if (!iconAfterText) ...[icon!, SizedBox(width: iconSpacing)],
        textWidget,

        //nếu iconAfterText == true thì hiện icon ở phía sau text
        if (iconAfterText) ...[SizedBox(width: iconSpacing), icon!],
      ],
    );
  }
}
