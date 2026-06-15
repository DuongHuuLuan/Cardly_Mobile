import 'dart:io';

import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final String? name;
  final String? imageUrl;
  final double? radius;
  final Color? backgroundColor;
  final TextStyle? nameStyle;
  const AppAvatar({
    super.key,
    this.name,
    this.imageUrl,
    this.nameStyle,
    this.radius = 24,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: imageUrl != null
          ? AppColor.greyLight
          : backgroundColor ?? AppColor.primary.withValues(alpha: 0.08),
      backgroundImage: imageUrl != null
          ? (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://')
                    ? NetworkImage(imageUrl!)
                    : FileImage(File(imageUrl!)))
                as ImageProvider
          : null,
      child: imageUrl == null
          ? Text(
              name!.isNotEmpty ? name![0].toUpperCase() : "?",
              style:
                  (radius! > 30
                          ? nameStyle ?? AppTextStyles.heading3
                          : nameStyle ?? AppTextStyles.bodySmall)
                      .copyWith(
                        color: AppColor.primary,
                        fontWeight: FontWeight.bold,
                      ),
            )
          : null,
    );
  }
}
