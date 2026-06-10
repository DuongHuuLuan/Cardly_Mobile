import 'package:flutter/material.dart';
import '../theme/app_color.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.1,

      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(strokeWidth: 3, color: AppColor.primary),

          Icon(Icons.credit_card, color: AppColor.primary, size: 30),
        ],
      ),
    );
  }
}
