import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_icon_action.dart';
import 'package:flutter/material.dart';

class ContactAppbarScreen extends StatelessWidget {
  const ContactAppbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Text("Contact", style: AppTextStyles.heading3),
              const Spacer(),
              AppIconAction(
                icon: Icons.add,
                containerSize: 30,
                containerColor: AppColor.greyLight,
              ),
            ],
          ),

          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: AppColor.greyLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by name, company, keyword...",
                hintStyle: AppTextStyles.bodySmall.copyWith(
                  color: AppColor.grey,
                ),
                prefixIcon: Icon(Icons.search, size: 22, color: AppColor.grey),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                // xử lý logic tìm kiếm contact
              },
            ),
          ),
        ],
      ),
    );
  }
}
