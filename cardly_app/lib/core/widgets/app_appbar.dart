import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:flutter/material.dart';

enum AppBarLeading { back, close, none }

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final AppBarLeading leadingType;
  final VoidCallback? onLeadingPressed;
  final List<Widget>? actions;
  final bool showBorder;
  final Color? backgroundColor;
  final double? elevation;
  final TextStyle? titleStyle;
  final bool? centerTitle;
  final Widget? titleWidget;
  final Color? iconLeadingColor;

  const AppAppBar({
    super.key,
    this.title,
    this.leadingType = AppBarLeading.back,
    this.onLeadingPressed,
    this.actions,
    this.showBorder = false,
    this.backgroundColor,
    this.elevation,
    this.titleStyle,
    this.centerTitle,
    this.titleWidget,
    this.iconLeadingColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColor.white,
      elevation: elevation,
      centerTitle: centerTitle ?? true,
      title:
          titleWidget ??
          (title != null
              ? Text(title!, style: titleStyle ?? AppTextStyles.heading3)
              : null),
      leading: _buildLeading(context),
      actions: actions,
      shape: showBorder
          ? Border(
              bottom: BorderSide(
                color: AppColor.greyLight.withValues(alpha: 0.5),
                width: 1,
              ),
            )
          : null,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    switch (leadingType) {
      case AppBarLeading.back:
        return IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: iconLeadingColor ?? AppColor.black,
          ),
          onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
        );
      case AppBarLeading.close:
        return IconButton(
          icon: Icon(
            Icons.close,
            color: iconLeadingColor ?? AppColor.black,
            size: 28,
          ),
          onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
        );
      case AppBarLeading.none:
        return null;
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
