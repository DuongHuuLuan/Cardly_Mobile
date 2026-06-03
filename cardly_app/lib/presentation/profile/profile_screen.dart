import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/core/widgets/app_bottom_nav.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:cardly_app/presentation/profile/widgets/profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  static const routerName = "/profile";
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: "Setting",
        onLeadingPressed: () => context.goToHome(),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            context.goToLogin();
          }
        },
        builder: (context, state) => ProfileContent(
          user: state.user,
          isLoading: state.status == AuthStatus.loading,
          onEdit: () {
            context.goToEditProfile();
          },
          onNotifications: () {},
          onPrivacy: () {},
          onHelp: () {},
          onLogout: () {
            context.read<AuthCubit>().logout();
          },
        ),
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: 2),
    );
  }
}
