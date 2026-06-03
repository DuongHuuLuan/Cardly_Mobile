import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_icon_action.dart';
import 'package:flutter/material.dart';

class ContactIconButton extends StatelessWidget {
  final VoidCallback? onCall;
  final VoidCallback? onEmail;
  final VoidCallback? onLinkedIn;
  final VoidCallback? onWebsite;

  const ContactIconButton({
    super.key,
    this.onCall,
    this.onEmail,
    this.onLinkedIn,
    this.onWebsite,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppIconAction(
          icon: Icons.phone_outlined,
          label: "Gọi",
          iconSize: 20,
          containerSize: 55,
          onTap: onCall,
        ),
        const SizedBox(width: 10),
        AppIconAction(
          icon: Icons.email_outlined,
          label: "Email",
          iconSize: 20,
          containerSize: 55,
          onTap: onEmail,
        ),
        const SizedBox(width: 10),
        AppIconAction(
          icon: Icons.phone_outlined,
          label: "LinkedIn",
          iconSize: 20,
          containerSize: 55,
          onTap: onLinkedIn,
        ),
        const SizedBox(width: 10),
        AppIconAction(
          icon: Icons.language_outlined,
          label: "Web",
          iconSize: 20,
          containerSize: 55,
          onTap: onWebsite,
        ),
      ],
    ).paddingHorizontal(16);
  }
}
