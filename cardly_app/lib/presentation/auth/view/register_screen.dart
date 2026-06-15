import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/widgets/app_alert_dialog.dart';
import 'package:cardly_app/core/widgets/app_loading_overlay.dart';
import 'package:cardly_app/core/widgets/password_strength_widget.dart';
import 'package:cardly_app/core/widgets/submit_button.dart';
import 'package:cardly_app/domain/entities/user_entity.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:cardly_app/presentation/auth/view/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  static const routerName = "/register";
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final AuthCubit _authCubit;

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _passwordValid = false;
  UserEntity? _pendingRegistrationUser;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_onEmailChanged);
    _authCubit = context.read<AuthCubit>();
  }

  void _onEmailChanged() {
    if (_authCubit.state.emailError != null) {
      _authCubit.clearEmailError();
    }
  }

  @override
  void dispose() {
    emailController.removeListener(_onEmailChanged);
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
        return;
      }

      final user = UserEntity(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      _pendingRegistrationUser = user;
      _authCubit.register(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == AuthStatus.loading) {
            context.showLoading("Creating account...");
          }
          if (state.status == AuthStatus.authenticated ||
              state.status == AuthStatus.registrationSuccess ||
              state.status == AuthStatus.failed) {
            context.hideLoading();
          }
          if (state.status == AuthStatus.failed) {
            final message =
                state.emailError ??
                state.errorMessage ??
                "An unknown error occurred";
            showDialog(
              context: context,
              builder: (_) => AppAlertDialog(
                icon: Icons.error_outline,
                color: AppColor.error,
                title: "Registration Failed",
                message: message,
                buttonLabel: "OK",
                onConfirm: () => Navigator.pop(context),
              ),
            );
          }

          if (state.status == AuthStatus.authenticated) {
            context.goToLogin();
          }
          if (state.status == AuthStatus.registrationSuccess &&
              _pendingRegistrationUser != null) {
            final user = _pendingRegistrationUser!;
            _pendingRegistrationUser = null;
            context.goToOtpVerificationRegister(user);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    Text(
                      "Sign Up",
                      style: AppTextStyles.heading1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    Text(
                      "Enter your information below",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColor.grey,
                      ),
                    ),
                    const SizedBox(height: 30),

                    AuthForm(
                      formKey: _formKey,
                      nameController: nameController,
                      emailController: emailController,
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      emailError: state.emailError,
                    ),
                    const SizedBox(height: 8),
                    PasswordStrengthWidget(
                      passwordController: passwordController,
                      onStrengthChanged: (v) =>
                          setState(() => _passwordValid = v),
                    ),

                    const SizedBox(height: 30),
                    SubmitButton(
                      controllers: [
                        nameController,
                        emailController,
                        passwordController,
                        confirmPasswordController,
                      ],
                      onPressed: () => _register(),
                      label: "Register",
                      canSubmit: _passwordValid,
                    ),

                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already a member?"),
                        TextButton(
                          onPressed: () {
                            context.goToLogin();
                          },
                          child: Text(
                            "Login",
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColor.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
