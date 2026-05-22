import 'package:flutter/material.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import '../crop_editor_controller.dart';

class AspectRatioBar extends StatelessWidget {
  final AspectRatioOption selected;
  final ValueChanged<AspectRatioOption> onChanged;

  const AspectRatioBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: AspectRatioOption.values.map((option) {
          final isSelected = option == selected;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(option.label, style: const TextStyle(fontSize: 11)),
              selected: isSelected,
              onSelected: (_) => onChanged(option),
              visualDensity: VisualDensity.compact,
              selectedColor: AppColor.primary.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: isSelected ? AppColor.primary : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
