import 'dart:io';

import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_avatar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DigitalCardPreview extends StatefulWidget {
  final String? name;
  final String? position;
  final String? company;
  final String? avatar;

  const DigitalCardPreview({
    super.key,
    this.name,
    this.position,
    this.company,
    this.avatar,
  });

  @override
  State<DigitalCardPreview> createState() => _DigitalCardPreviewState();
}

class _DigitalCardPreviewState extends State<DigitalCardPreview> {
  String? _cardImagePath;

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
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: _cardImagePath != null
            ? null
            : const LinearGradient(
                colors: [AppColor.primary, Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        boxShadow: _cardImagePath != null
            ? [
                BoxShadow(
                  color: AppColor.greyLight.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: AppColor.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: _cardImagePath != null
          ? Stack(
              children: [
                Image.file(
                  File(_cardImagePath!),
                  height: MediaQuery.of(context).size.height * 0.23,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
                Positioned(
                  top: 3,
                  left: 0,
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
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppAvatar(
                  name: widget.name![0],
                  imageUrl: widget.avatar,
                  radius: 30,
                  backgroundColor: AppColor.grey,
                ),
                const SizedBox(height: 24),
                Text(
                  widget.name!,
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
                const SizedBox(height: 10),
                Text(
                  "Add a short bio about yourself...",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColor.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
    );
  }
}
