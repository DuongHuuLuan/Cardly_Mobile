import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:cardly_app/presentation/auth/view/login_page.dart';
import 'package:cardly_app/presentation/home/view/widgets/document_card.dart';
import 'package:cardly_app/domain/enums/document_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

extension HomeNavigation on BuildContext {
  void goToHome() => go('/home');
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DocumentType? _selectedType;
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose your document type",
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(left: 40, right: 40),
                children: [
                  DocumentCard(
                    imagePath: 'assets/images/passport_card.jpg',
                    title: 'Passport',
                    isSelected: _selectedType == DocumentType.passport,
                    onTap: () =>
                        setState(() => _selectedType = DocumentType.passport),
                  ),
                  const SizedBox(height: 30),
                  DocumentCard(
                    imagePath: 'assets/images/driver_licence.jpg',
                    title: 'Driver Licence',
                    isSelected: _selectedType == DocumentType.driverLicence,
                    onTap: () => setState(
                      () => _selectedType = DocumentType.driverLicence,
                    ),
                  ),
                  const SizedBox(height: 30),
                  DocumentCard(
                    imagePath: 'assets/images/medicare_card.png',
                    title: 'Medicare Card',
                    isSelected: _selectedType == DocumentType.medicareCard,
                    onTap: () => setState(
                      () => _selectedType = DocumentType.medicareCard,
                    ),
                  ),
                ],
              ),
            ),
            if (_selectedType != null) ...[
              SizedBox(
                width: double.infinity,
                child: AppElevatedButton(
                  label: "Let's Begin",
                  onPressed: () => context.go('/scan', extra: _selectedType),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}
