import 'package:cardly_app/presentation/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:cardly_app/core/widgets/app_text_form_field.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';

extension LoginNavigation on BuildContext {
  void goToLogin() => go('/login');
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
      return;
    }
    context.read<AuthCubit>().login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.failed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? "Login failed")),
            );
          }
          if (state.status == AuthStatus.authenticated) {
            context.goToHome();
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Welcome to Cardly",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Scan business cards intelligently",
                    style: TextStyle(fontSize: 16, color: AppColor.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  AppTextFormField(
                    controller: emailController,
                    labelText: "Email",
                    hintText: "Enter your email",
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),
                  AppTextFormField(
                    controller: passwordController,
                    labelText: "Password",
                    hintText: "Enter your password",
                    prefixIcon: Icons.lock_outlined,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  AppElevatedButton(
                    label: "Login",
                    onPressed: _login,
                    backgroundColor: AppColor.primary,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Feature coming soon")),
                      );
                    },
                    child: const Text("Forgot Password?"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
