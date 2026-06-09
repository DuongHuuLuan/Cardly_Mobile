import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_alert_dialog.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/core/widgets/app_loading_overlay.dart';
import 'package:cardly_app/core/widgets/submit_button.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:cardly_app/presentation/auth/view/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routerName = "/forgot-password";
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
      appBar: AppAppBar(
        title: "Forgot Password",
        onLeadingPressed: () => context.goToLogin(),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == AuthStatus.forgotPasswordLoading) {
            context.showLoading("Sending email...");
          }
          if (state.status == AuthStatus.failed ||
              state.status == AuthStatus.forgotPasswordSuccess ||
              state.status == AuthStatus.forgotPasswordFailure) {
            context.hideLoading();
          }
          if (state.status == AuthStatus.forgotPasswordSuccess) {
            context.goToOtpVerificationForgotPassword(
              emailController.text.trim(),
            );
          } else if (state.status == AuthStatus.forgotPasswordFailure &&
              state.errorMessage != null) {
            showDialog(
              context: context,
              builder: (context) => AppAlertDialog(
                title:
                    state.errorMessage ??
                    "This email address has not been registered.",
                onConfirm: () => context.pop(),
              ),
            );
          }
        },
        builder: (context, state) => Column(
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
        ).paddingAll(16),
      ),
    );
  }
}
