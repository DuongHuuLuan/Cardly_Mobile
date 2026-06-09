import 'dart:io';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
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
            '${imagePaths.length}/2 card${imagePaths.length > 1 ? 's' : ''} selected',
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
                  GestureDetector(
                    onTap: () => _showPreview(context, index),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(imagePaths[index]),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => onRemove(index),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColor.black87,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close,
                          color: AppColor.white,
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
                label: const Text('Add card'),
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
          AppElevatedButton(
            label: 'Confirm & Upload',
            onPressed: onConfirm,
            labelColor: AppColor.white,
          ),
        ],
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
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
        ).paddingVertical(16),
      ),
    );
  }

  void _showPreview(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ImagePreviewPage(
          imagePaths: imagePaths,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class _ImagePreviewPage extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;
  const _ImagePreviewPage({
    required this.imagePaths,
    required this.initialIndex,
  });

  @override
  State<_ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<_ImagePreviewPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppAppBar(
        title: 'Preview (${_currentIndex + 1}/${widget.imagePaths.length})',
        leadingType: AppBarLeading.close,
        backgroundColor: AppColor.black,
        iconLeadingColor: AppColor.white,
        titleStyle: const TextStyle(color: AppColor.white),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imagePaths.length,
        onPageChanged: (i) => setState(() => _currentIndex = i),
        itemBuilder: (ctx, i) => InteractiveViewer(
          child: Center(child: Image.file(File(widget.imagePaths[i]))),
        ),
      ),
    );
  }
}
