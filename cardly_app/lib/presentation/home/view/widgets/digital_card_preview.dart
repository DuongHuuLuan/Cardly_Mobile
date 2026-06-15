import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/permission_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DigitalCardPreview extends StatefulWidget {
  final String name;
  final String position;
  final String company;
  final VoidCallback? onViewDetail;
  const DigitalCardPreview({
    super.key,
    required this.name,
    required this.position,
    required this.company,
    this.onViewDetail,
  });

  @override
  State<DigitalCardPreview> createState() => _DigitalCardPreviewState();
}

class _DigitalCardPreviewState extends State<DigitalCardPreview> {
  String? _cardImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadCardImagePath();
  }

  Future<void> _loadCardImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _cardImagePath = prefs.getString('card_image_path');
    });
  }

  void _showImagePickerOptions() {
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
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.gallery) {
      final granted = await requestGalleryPermission(context);
      if (!granted || !mounted) return;
    }
    try {
      final file = await _picker.pickImage(source: source);
      if (file == null) return;
      final savedPath = await _saveImageToTemp(file);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('card_image_path', savedPath);
      if (!mounted) return;
      setState(() {
        _cardImagePath = savedPath;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  Future<String> _saveImageToTemp(XFile file) async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File(path).writeAsBytes(await file.readAsBytes());
    return path;
  }

  Future<void> _removeCardImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('card_image_path');
    if (!mounted) return;
    setState(() {
      _cardImagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _cardImagePath != null ? widget.onViewDetail : null,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.22,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: _cardImagePath != null
              ? null
              : const LinearGradient(
                  colors: [AppColor.primary, Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColor.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: _cardImagePath != null
            ? Stack(
                children: [
                  Positioned.fill(
                    child: Image.file(File(_cardImagePath!), fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: InkWell(
                      onTap: _removeCardImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppColor.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 24,
                    right: 24,
                    child: InkWell(
                      onTap: _showImagePickerOptions,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: AppColor.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: 10,
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.credit_card_outlined,
                              color: AppColor.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "My business card number",
                              style: AppTextStyles.caption.copyWith(
                                color: AppColor.grey,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: _showImagePickerOptions,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColor.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_a_photo,
                                  color: AppColor.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.name,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${widget.position} · ${widget.company}",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColor.grey,
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColor.white54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: widget.onViewDetail,
                            child: Text(
                              "See details",
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColor.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
