import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:cardly_app/presentation/digital_card/widgets/digital_card_preview.dart';
import 'package:cardly_app/presentation/digital_card/widgets/digital_card_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/navigation_exp.dart';

class DigitalCardScreen extends StatelessWidget {
  static const routerName = "/digital-card";
  const DigitalCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: "Business card number",
        showBorder: true,
        onLeadingPressed: () => context.goToHome(),
        actions: [
          TextButton(
            onPressed: () => context.goToProfile(),
            child: Text(
              "Edit",
              style: AppTextStyles.bodyMedium.copyWith(color: AppColor.grey),
            ),
          ).paddingOnly(right: 8.0),
        ],
        titleStyle: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),

      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final user = state.status == AuthStatus.authenticated
              ? state.user!
              : null;

          final name = user?.name ?? "Your Name";
          final company = user?.company ?? "Your Company";
          final position = user?.position ?? "Your position";
          final cardUrl = user?.cardUrl ?? "Your cardUrl";

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DigitalCardPreview(
                    name: name,
                    company: company,
                    position: position,
                    avatar: user?.avatar,
                  ),
                  const SizedBox(height: 20),
                  DigitalCardShare(cardUrl: cardUrl),
                ],
              ),
            ),
          ).paddingAll(24);
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
          color: AppColor.primary,
          shape: BoxShape.circle,
        ),
        child: RawMaterialButton(
          shape: const CircleBorder(),
          onPressed: () {},
          child: Icon(Icons.qr_code_scanner, color: AppColor.white, size: 28),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        color: AppColor.white,
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  context.goToHome();
                },
                icon: Icon(Icons.credit_card_outlined, color: AppColor.grey),
              ),

              IconButton(onPressed: () {}, icon: Icon(null)),
              IconButton(
                icon: const Icon(Icons.people_outline, color: AppColor.grey),
                onPressed: () {
                  context.goToProfile();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
