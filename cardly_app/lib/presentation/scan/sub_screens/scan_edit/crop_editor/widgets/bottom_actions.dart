import 'package:flutter/material.dart';
import 'package:cardly_app/core/theme/app_color.dart';

class BottomActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final bool isLoading;

  const BottomActions({
    super.key,
    required this.onCancel,
    required this.onConfirm,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      // decoration: BoxDecoration(
      //   boxShadow: [BoxShadow(blurRadius: 10, offset: const Offset(0, -4))],
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColor.white),
            onPressed: onCancel,
            tooltip: 'Cancel',
          ),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              // color: AppColor.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: isLoading
                  ? CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor.white,
                    )
                  : const Icon(Icons.check, color: AppColor.white, size: 28),
              onPressed: isLoading ? null : onConfirm,
              tooltip: 'Confirm',
            ),
          ),
        ],
      ),
    );
  }
}
