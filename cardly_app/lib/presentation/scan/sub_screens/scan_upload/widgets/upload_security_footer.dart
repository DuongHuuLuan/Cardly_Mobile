import 'package:flutter/material.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';

class UploadSecurityFooter extends StatelessWidget {
  const UploadSecurityFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.gpp_good_outlined, size: 16, color: AppColor.grey),
        const SizedBox(width: 4),
        Text("SSL Encryption", style: AppTextStyles.caption),
        const SizedBox(width: 16),
        Container(width: 1, height: 12, color: AppColor.greyLight),
        const SizedBox(width: 16),
        const Icon(Icons.wifi, size: 16, color: AppColor.grey),
        const SizedBox(width: 4),
        Text("Stable Connection", style: AppTextStyles.caption),
      ],
    );
  }
}
