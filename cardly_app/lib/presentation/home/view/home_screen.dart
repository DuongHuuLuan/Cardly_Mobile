import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_bottom_nav.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:cardly_app/presentation/home/view/widgets/digital_card_preview.dart';
import 'package:cardly_app/presentation/home/view/widgets/home_header.dart';
import 'package:cardly_app/presentation/home/view/widgets/recent_contacts_section.dart';
import 'package:cardly_app/presentation/home/view/widgets/scan_action_button.dart';
import 'package:cardly_app/presentation/home/view/widgets/stats_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  static const routerName = "/home";

  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final user = state.status == AuthStatus.authenticated
              ? state.user!
              : null;
          final userName = user?.name ?? "Your Name";
          final position = user?.position ?? "Your Position";
          final company = user?.company ?? "Your Company";
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  HomeHeader(
                    userName: userName,
                    onSettings: () => context.goToProfile(),
                  ).paddingOnly(left: 20, right: 20),

                  const SizedBox(height: 28),
                  DigitalCardPreview(
                    name: userName,
                    position: position,
                    company: company,
                    onViewDetail: () {
                      context.goToDigitalCard();
                    },
                  ).paddingHorizontal(20),

                  const SizedBox(height: 20),
                  ScanActionButton(
                    onTap: () => context.goToScan(),
                  ).paddingHorizontal(20),

                  const SizedBox(height: 28),
                  RecentContactsSection(onViewAll: () => context.goToContact()),
                  const SizedBox(height: 28),
                  const StatsOverview(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
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
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}
