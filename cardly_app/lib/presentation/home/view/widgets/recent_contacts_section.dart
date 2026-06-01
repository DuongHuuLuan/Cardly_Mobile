import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_avatar.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_cubit.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_state.dart';
import 'package:cardly_app/presentation/contact/view/contact_detail/contact_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentContactsSection extends StatelessWidget {
  final VoidCallback? onViewAll;
  const RecentContactsSection({super.key, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ContactCubit>().state;
    final contacts = state.contacts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
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
          ),
        ),
        const SizedBox(height: 12),

        if (state.status == ContactStatus.loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (contacts.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                "No contacts yet",
                style: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: contacts.map((c) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        leading: AppAvatar(radius: 24, name: c.fullName ?? "?"),

                        title: Text(
                          c.fullName ?? 'Unknown',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          "${c.jobTitle ?? ''} · ${c.company ?? ''}",
                          style: AppTextStyles.caption,
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColor.grey,
                          size: 22,
                        ),
                        onTap: () => _onContactTap(context, c),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  void _onContactTap(BuildContext context, BusinessCardEntity contact) {
    context.goToContactDetail(contact);
  }
}
