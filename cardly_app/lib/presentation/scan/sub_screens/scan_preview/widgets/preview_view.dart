import 'dart:io';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:flutter/material.dart';

class PreviewView extends StatelessWidget {
  final List<String> imagePaths;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onConfirm;
  final void Function(int) onRemove;
  final bool canAddMore;
  const PreviewView({
    super.key,
    required this.imagePaths,
    required this.onCamera,
    required this.onGallery,
    required this.onConfirm,
    required this.onRemove,
    required this.canAddMore,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('Review your cards', style: AppTextStyles.heading2),
          const SizedBox(height: 8),
          Text(
            '${imagePaths.length} card${imagePaths.length > 1 ? 's' : ''} selected',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColor.greyDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: imagePaths.length,
              itemBuilder: (context, index) => Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(imagePaths[index]),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => onRemove(index),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (canAddMore) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showAddOptions(context),
                icon: const Icon(Icons.add),
                label: const Text('Add another card'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.primary,
                  side: const BorderSide(color: AppColor.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          AppElevatedButton(label: 'Confirm & Upload', onPressed: onConfirm),
        ],
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  onCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  onGallery();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
