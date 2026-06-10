import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:flutter/material.dart';

class ContactDetailImageGallery extends StatelessWidget {
  final List<String>? images;

  const ContactDetailImageGallery({super.key, this.images});

  @override
  Widget build(BuildContext context) {
    if (images == null || images!.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: images!.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final w = MediaQuery.of(context).size.width * 0.13;
              return GestureDetector(
                onTap: () => _showFullScreen(context, images![index]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    images![index],
                    width: w,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Container(
                      width: w,
                      color: AppColor.greyLight,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _showFullScreen(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: AppColor.black,
          appBar: AppAppBar(
            leadingType: AppBarLeading.close,
            backgroundColor: AppColor.black,
            iconLeadingColor: AppColor.white,
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}
