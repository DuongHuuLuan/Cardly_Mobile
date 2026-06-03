import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:flutter/material.dart';

class _StatItem {
  final IconData icon;
  final String value;
  final String label;
  const _StatItem(this.icon, this.value, this.label);
}

const _stats = [
  _StatItem(Icons.people_outline, "3", "Contact"),
  _StatItem(Icons.business_outlined, "3", "Company"),
  _StatItem(Icons.auto_awesome_outlined, "3", "Already rich"),
];

class StatsOverview extends StatelessWidget {
  const StatsOverview({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Statistical",
            style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold),
          ).paddingHorizontal(5),

          const SizedBox(height: 12),
          Row(
            children: List.generate(_stats.length, (i) {
              final s = _stats[i];
              return Expanded(
                child: Container(
                  height: 100,
                  margin: EdgeInsets.only(left: i > 0 ? 12 : 0),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(s.icon, size: 24, color: AppColor.greyDark),
                      const SizedBox(height: 8),
                      Text(
                        s.value,
                        style: AppTextStyles.heading3.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(s.label, style: AppTextStyles.caption),
                    ],
                  ),
                ),
              );
            }),
          ).paddingHorizontal(5),
        ],
      ),
    ).paddingOnly(left: 20, right: 20, bottom: 20);
  }
}
