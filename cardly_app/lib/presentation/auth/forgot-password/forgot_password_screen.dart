import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_alert_dialog.dart';
import 'package:cardly_app/core/widgets/submit_button.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:cardly_app/presentation/auth/view/login_screen.dart';
import 'package:cardly_app/presentation/auth/view/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

extension ForgotPasswordNavigation on BuildContext {
  void goToForgotPassword() => go('/forgot-password');
  void goToOtpVerification(String email) => go('/verify-otp', extra: email);
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final AuthCubit _authCubit;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password", style: AppTextStyles.heading3),
        leading: IconButton(
          onPressed: () => context.goToLogin(),
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.forgotPasswordSuccess) {
            context.goToOtpVerification(emailController.text.trim());
          } else if (state.status == AuthStatus.forgotPasswordFailure &&
              state.errorMessage != null) {
            showDialog(
              context: context,
              builder: (context) => AppAlertDialog(
                title: "This email address has not been registered.",
                onConfirm: () => context.pop(),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                "Enter your email address, We will send OTP code "
                "for verification in the next step.",
                style: AppTextStyles.bodyMedium.copyWith(color: AppColor.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              AuthForm(formKey: _formKey, emailController: emailController),
              const SizedBox(height: 10),
              SubmitButton(
                controllers: [emailController],
                onPressed: () {
                  final email = emailController.text.trim();
                  if (email.isEmpty) return;
                  _authCubit.forgotPassword(email);
                },
                label: "Send OTP",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
