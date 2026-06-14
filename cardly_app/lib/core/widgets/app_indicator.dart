import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_page_indicator.dart';
import 'package:flutter/material.dart';

class AppIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback? onSkip;
  final VoidCallback? onBack;
  final bool showSkip;
  // Labels
  final String nextLabel;
  final String getStartedLabel;
  final String skipLabel;
  final String backLabel;

  // Button
  final Color buttonColor;
  final Color buttonTextColor;
  final Color buttonDisabledColor;
  final double buttonHeight;
  final double buttonRadius;
  final TextStyle? buttonTextStyle;

  final Color backButtonColor;
  final Color backButtonTextColor;
  // Skip
  final Color? skipTextColor;
  final TextStyle? skipTextStyle;
  // Dots
  final Color? dotsActiveColor;
  final Color? dotsInactiveColor;
  final double? dotsActiveWidth;
  final double? dotsInactiveWidth;
  final double? dotsHeight;
  // Layout
  final double dotsToButtonGap;
  final double skipToDotsGap;
  final EdgeInsetsGeometry padding;
  const AppIndicator({
    super.key,
    required this.currentIndex,
    required this.totalPages,
    required this.onNext,
    this.onSkip,
    this.onBack,
    this.showSkip = true,
    this.nextLabel = "Next",
    this.getStartedLabel = "Get Started",
    this.skipLabel = "Skip",
    this.backLabel = "Back",
    this.buttonColor = AppColor.primary,
    this.buttonTextColor = AppColor.white,
    this.buttonDisabledColor = AppColor.greyLight,
    this.buttonHeight = 56,
    this.buttonRadius = 12,
    this.buttonTextStyle,
    this.backButtonColor = AppColor.greyLight,
    this.backButtonTextColor = AppColor.greyDark,
    this.skipTextColor = AppColor.grey,
    this.skipTextStyle,
    this.dotsActiveColor,
    this.dotsInactiveColor,
    this.dotsActiveWidth,
    this.dotsInactiveWidth,
    this.dotsHeight,
    this.dotsToButtonGap = 32,
    this.skipToDotsGap = 24,
    this.padding = EdgeInsets.zero,
  });
  bool get _isLastPage => currentIndex == totalPages - 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dots
        AppPageIndicator(
          currentIndex: currentIndex,
          count: totalPages,
          activeColor: dotsActiveColor ?? AppColor.primary,
          inactiveColor: dotsInactiveColor ?? AppColor.greyLight,
          activeWidth: dotsActiveWidth ?? 24,
          inactiveWidth: dotsInactiveWidth ?? 10,
          height: dotsHeight ?? 10,
        ),
        SizedBox(height: dotsToButtonGap),
        // Buttons
        if (onBack != null && currentIndex > 0)
          Row(
            children: [
              Expanded(
                child: _buildButton(
                  label: backLabel,
                  icon: Icons.arrow_back_ios,
                  iconOnRight: false,
                  backgroundColor: backButtonColor,
                  foregroundColor: backButtonTextColor,
                  onPressed: onBack!,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildNextButton()),
            ],
          )
        else
          _buildNextButton(),
        const SizedBox(height: 20),
        // Skip
        if (showSkip)
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: onSkip,
              child: Text(
                skipLabel,
                style:
                    skipTextStyle ??
                    AppTextStyles.bodyMedium.copyWith(
                      color: skipTextColor ?? AppColor.grey,
                      fontWeight: FontWeight.w500,
                    ),
              ).paddingHorizontal(8).paddingVertical(4),
            ),
          ),
        if (showSkip) SizedBox(height: skipToDotsGap),
      ],
    ).padding(padding);
  }

  Widget _buildNextButton() {
    return _buildButton(
      label: _isLastPage ? getStartedLabel : nextLabel,
      icon: Icons.arrow_forward_ios,
      iconOnRight: true,
      backgroundColor: buttonColor,
      foregroundColor: buttonTextColor,
      onPressed: onNext,
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required bool iconOnRight,
    required Color backgroundColor,
    required Color foregroundColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: buttonDisabledColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!iconOnRight) Icon(icon, size: 14).paddingRight(6),
            Text(
              label,
              style:
                  buttonTextStyle ??
                  AppTextStyles.bodyMedium.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (iconOnRight) Icon(icon, size: 15).paddingLeft(10),
          ],
        ),
      ),
    );
  }
}
