import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_contact_card.dart';
import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentContactsSection extends StatelessWidget {
  final VoidCallback? onViewAll;
  const RecentContactsSection({super.key, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ContactCubit>().state;
    final contacts = state.contacts.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Recent Contact",
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: onViewAll,
              child: Text(
                "View all",
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColor.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ).paddingHorizontal(20),
        const SizedBox(height: 12),
        if (contacts.isEmpty)
          Center(
            child: Text(
              "No contacts yet",
              style: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
            ),
          ).paddingVertical(24)
        else
          Column(
            children: contacts.map((c) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppContactCard(
                  contact: c,
                  onTap: () => _onContactTap(context, c),
                ),
              );
            }).toList(),
          ).paddingHorizontal(16),
      ],
    );
  }

  void _onContactTap(BuildContext context, BusinessCardEntity contact) {
    context.goToContactDetail(contact.id!);
  }
}
