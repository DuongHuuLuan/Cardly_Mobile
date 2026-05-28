import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_bottom_nav.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:cardly_app/presentation/auth/view/login_screen.dart';
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
        title: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final username = state.status == AuthStatus.authenticated
                ? state.user!.name
                : "User";
            return Text(
              "Hello, $username",
              style: AppTextStyles.heading3.copyWith(color: AppColor.black87),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
              context.goToLogin();
            },
            icon: const Icon(Icons.logout, color: AppColor.grey),
          ),
        ],
      ),

      bottomNavigationBar: AppBottomNav(currentIndex: 3),
    );
  }
}
