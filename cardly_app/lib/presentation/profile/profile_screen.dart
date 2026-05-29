import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_bottom_nav.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:cardly_app/presentation/auth/view/login_screen.dart';
import 'package:cardly_app/presentation/home/view/home_screen.dart';
import 'package:cardly_app/presentation/profile/widgets/profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

extension ProfileNavigation on BuildContext {
  void goToProfile() => go('/profile');
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting", style: AppTextStyles.heading3),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.goToHome(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) => ProfileContent(
          user: state.user,
          onEdit: () {
            // TODO: navigate to edit profile
          },
          onNotifications: () {
            // TODO: navigate to notifications
          },
          onPrivacy: () {
            // TODO: navigate to privacy
          },
          onHelp: () {
            // TODO: navigate to help
          },
          onLogout: () {
            context.read<AuthCubit>().logout();
            context.goToLogin();
          },
        ),
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: 2),
    );
  }
}
