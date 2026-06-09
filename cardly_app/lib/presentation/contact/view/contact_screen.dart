import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_bottom_nav.dart';
import 'package:cardly_app/core/widgets/app_contact_card.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_cubit.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_state.dart';
import 'package:cardly_app/presentation/contact/view/widgets/contact_appbar_screen.dart';
import 'package:cardly_app/presentation/scan/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'contact_detail/contact_detail_screen.dart';

extension ContactNavigation on BuildContext {
  void goToContact() => push('/contact');
}

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: AppColor.white),
            child: ContactAppbarScreen(),
          ),

          Expanded(
            child: BlocBuilder<ContactCubit, ContactState>(
              builder: (context, state) {
                if (state.status == ContactStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.contacts.isEmpty) {
                  return Center(
                    child: Text(
                      "No contact",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColor.grey,
                      ),
                    ),
                  );
                }
                final grouped = _groupContacts(state.contacts);

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: grouped.entries.expand((entry) {
                    return [
                      _SectionHeader(letter: entry.key),
                      ...entry.value.map(
                        (contact) => AppContactCard(
                          contact: contact,
                          onTap: () => context.goToContactDetail(contact),
                        ),
                      ),
                    ];
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.width * 0.15,
        decoration: const BoxDecoration(
          color: AppColor.primary,
          shape: BoxShape.circle,
        ),
        child: RawMaterialButton(
          shape: const CircleBorder(),
          onPressed: () => context.goToScan(),
          child: const Icon(
            Icons.camera_enhance,
            color: AppColor.white,
            size: 28,
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: 2),
    );
  }

  Map<String, List<BusinessCardEntity>> _groupContacts(
    List<BusinessCardEntity> contacts,
  ) {
    final sorted = List<BusinessCardEntity>.from(contacts)
      ..sort((a, b) => (a.fullName ?? '').compareTo(b.fullName ?? ''));
    final map = <String, List<BusinessCardEntity>>{};
    for (final c in sorted) {
      final letter = (c.fullName ?? '?')[0].toUpperCase();
      map.putIfAbsent(letter, () => []);
      map[letter]!.add(c);
    }
    return map;
  }
}

class _SectionHeader extends StatelessWidget {
  final String letter;
  const _SectionHeader({required this.letter});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8, left: 4),
      child: Text(
        letter,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColor.greyDark,
        ),
      ),
    );
  }
}
