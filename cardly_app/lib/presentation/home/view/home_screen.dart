import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:cardly_app/presentation/auth/view/login_page.dart';
import 'package:cardly_app/presentation/home/view/widgets/quick_action_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

extension HomeNavigation on BuildContext {
  void goToHome() => go('/home');
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What do you want to do?",
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                children: [
                  QuickActionCard(
                    icon: Icons.camera_alt_outlined,
                    label: 'Scan Business Card',
                    color: AppColor.primary,
                    onTap: () => context.go('/scan'),
                  ),
                  const SizedBox(height: 20),
                  QuickActionCard(
                    icon: Icons.edit_note_outlined,
                    label: 'Manual Entry',
                    color: AppColor.primary,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming soon')),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  QuickActionCard(
                    icon: Icons.person_outline,
                    label: 'My Digital Card',
                    color: AppColor.primary,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming soon')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
