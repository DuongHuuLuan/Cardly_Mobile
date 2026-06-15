import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_bottom_nav.dart';
import 'package:cardly_app/core/widgets/app_contact_card.dart';
import 'package:cardly_app/core/widgets/app_loading_overlay.dart';
import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:cardly_app/presentation/auth/view/session_expired_screen.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_cubit.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_state.dart';
import 'package:cardly_app/presentation/contact/view/widgets/contact_appbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ContactScreen extends StatefulWidget {
  static const routerName = "/contact";

  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ContactCubit>().loadMore();
    }
  }

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
            child: BlocConsumer<ContactCubit, ContactState>(
              listenWhen: (previous, current) {
                return previous.status != current.status;
              },
              listener: (context, state) {
                if (state.status == ContactStatus.loading) {
                  context.showLoading("Synchronizing...");
                }

                if (state.status == ContactStatus.loaded ||
                    state.status == ContactStatus.failure) {
                  context.hideLoading();
                }

                if (state.status == ContactStatus.failure &&
                    state.errorMessage == "The login session has expired.") {
                  context.go(SessionExpiredScreen.routerName);
                }
              },
              builder: (context, state) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!context.mounted) return;

                  if (state.status == ContactStatus.loading) {
                    context.showLoading("Synchronizing...");
                  } else {
                    context.hideLoading();
                  }
                });

                if (state.status == ContactStatus.loading &&
                    state.contacts.isEmpty) {
                  return const SizedBox.shrink();
                }

                if (state.contacts.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => context.read<ContactCubit>().loadContacts(
                      refresh: true,
                    ),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(
                            child: Text(
                              "No contact",
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColor.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final grouped = _groupContacts(state.contacts);

                return RefreshIndicator(
                  onRefresh: () =>
                      context.read<ContactCubit>().loadContacts(refresh: true),
                  child: ListView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      ...grouped.entries.expand((entry) {
                        return [
                          _SectionHeader(letter: entry.key),
                          ...entry.value.map(
                            (contact) => AppContactCard(
                              contact: contact,
                              onTap: () {
                                context.goToContactDetail(contact.id!);
                              },
                            ),
                          ),
                        ];
                      }),
                      if (state.isLoadingMore)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
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
    return Text(
      letter,
      style: AppTextStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColor.greyDark,
      ),
    ).paddingOnly(top: 12, bottom: 8, left: 4);
  }
}
