import 'package:cardly_app/presentation/scan/crop_editor/crop_editor_state.dart';
import 'package:flutter/material.dart';
import 'package:cardly_app/core/theme/app_color.dart';

class ModeToggleBar extends StatelessWidget {
  final CropEditorMode currentMode;
  final ValueChanged<CropEditorMode> onChanged;

  const ModeToggleBar({
    super.key,
    required this.currentMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          _buildModeChip('Crop', Icons.crop, CropEditorMode.crop),
          const SizedBox(width: 8),
          // _buildModeChip(
          //   'Perspective',
          //   Icons.transform,
          //   CropEditorMode.perspective,
          // ),
        ],
      ),
    );
  }

  Widget _buildModeChip(String label, IconData icon, CropEditorMode mode) {
    final isSelected = mode == currentMode;
    return GestureDetector(
      onTap: () => onChanged(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary : AppColor.grey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColor.white : AppColor.black87,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColor.white : AppColor.black87,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
