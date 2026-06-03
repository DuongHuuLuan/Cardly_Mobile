import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/widgets/app_alert_dialog.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:cardly_app/core/widgets/app_password_text_form_field.dart';
import 'package:cardly_app/core/widgets/password_strength_widget.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const routerName = "/reset-password";

  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final AuthCubit _authCubit;
  late String _email;
  late String _otp;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordValid = false;

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = GoRouterState.of(context).extra as Map<String, String>;
    _email = args['email']!;
    _otp = args['otp']!;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _save() {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }
    _authCubit.resetPassword(_email, _otp, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(onLeadingPressed: () => context.goToForgotPassword()),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.resetPasswordFailure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColor.error,
              ),
            );
          }
          if (state.status == AuthStatus.resetPasswordSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AppAlertDialog(
                icon: Icons.check_circle,
                color: AppColor.success,
                title: "Reset Password Successfully",
                message: "Your password has been updated successfully",
                buttonLabel: "Go to Login",
                onConfirm: () {
                  Navigator.pop(context);
                  context.goToLogin();
                },
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == AuthStatus.resetPasswordLoading;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Enter New Password",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Please enter your new password",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColor.greyDark,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 50),
                AppPasswordTextFormField(
                  controller: _passwordController,
                  labelText: "Password",
                  hintText: "Enter password",
                ),

                const SizedBox(height: 20),
                AppPasswordTextFormField(
                  controller: _confirmPasswordController,
                  labelText: "Confirm Password",
                  hintText: "Confirm password",
                ),
                const SizedBox(height: 8),
                PasswordStrengthWidget(
                  passwordController: _passwordController,
                  onStrengthChanged: (v) => setState(() => _passwordValid = v),
                ),
                const SizedBox(height: 40),
                AppElevatedButton(
                  label: "Save",
                  onPressed: _passwordValid ? _save : null,
                  labelStyle: AppTextStyles.bodyLarge.copyWith(
                    color: AppColor.white,
                  ),
                  isLoading: isLoading,
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
