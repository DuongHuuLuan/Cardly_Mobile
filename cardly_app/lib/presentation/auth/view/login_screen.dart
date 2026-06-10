import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_alert_dialog.dart';
import 'package:cardly_app/core/widgets/app_loading_overlay.dart';
import 'package:cardly_app/core/widgets/submit_button.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:cardly_app/presentation/auth/view/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static const routerName = "/login";
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthCubit _authCubit;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _lockoutDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
    emailController.addListener(_onEmailChanged);
    passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    emailController.removeListener(_onEmailChanged);
    passwordController.removeListener(_onPasswordChanged);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    if (_authCubit.state.emailError != null) {
      _authCubit.clearEmailError();
    }
  }

  void _onPasswordChanged() {
    if (_authCubit.state.passwordError != null) {
      _authCubit.clearPasswordError();
    }
  }

  void _login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    _authCubit.login(email, password);
  }

  void _showLockoutDialog() {
    if (_lockoutDialogShowing) return;
    _lockoutDialogShowing = true;
    final cubit = context.read<AuthCubit>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StreamBuilder<AuthState>(
          stream: cubit.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            final seconds = snapshot.data!.lockoutSeconds;
            if (seconds <= 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (ctx.mounted) Navigator.pop(ctx);
                _lockoutDialogShowing = false;
              });
              return const SizedBox.shrink();
            }
            return AppAlertDialog(
              title: "Too Many Attempts",
              message: "Please try again in $seconds seconds.",
              onConfirm: () {},
            );
          },
        );
      },
    ).then((_) => _lockoutDialogShowing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == AuthStatus.loading) {
            context.showLoading("Signing in...");
          }

          if (state.status == AuthStatus.authenticated ||
              state.status == AuthStatus.failed) {
            context.hideLoading();
          }

          if (state.status == AuthStatus.authenticated) {
            context.goToHome();
          } else if (state.status == AuthStatus.failed &&
              state.lockoutSeconds > 0) {
            _showLockoutDialog();
          } else if (state.errorMessage != null &&
              state.status != AuthStatus.loading) {
            showDialog(
              context: context,
              builder: (dialogContext) => AppAlertDialog(
                icon: Icons.error_outline,
                color: AppColor.error,
                title: "Login Failed",
                message: state.errorMessage,
                buttonLabel: "OK",
                onConfirm: () => Navigator.pop(dialogContext),
              ),
            );
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
                      "Sign In",
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Enter your information below",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColor.grey),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColor.greyLight)),
                        Text(
                          "Or login with",
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColor.greyDark),
                        ).paddingHorizontal(16),

                        Expanded(child: Divider(color: AppColor.greyLight)),
                      ],
                    ),
                    const SizedBox(height: 35),
                    AuthForm(
                      formKey: _formKey,
                      emailController: emailController,
                      passwordController: passwordController,
                      emailError: state.emailError,
                      passwordError: state.passwordError,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.goToForgotPassword(),
                        child: Text(
                          "Forgot Password?",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColor.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SubmitButton(
                      controllers: [emailController, passwordController],
                      onPressed: () {
                        if (_formKey.currentState!.validate()) _login();
                      },
                      label: "Login",
                      canSubmit: state.lockoutSeconds == 0,
                      isLoading: state.status == AuthStatus.loading,
                    ),
                    if (state.lockoutSeconds > 0)
                      Text(
                        "Too many attempts. Try again in ${state.lockoutSeconds}s",
                        style: const TextStyle(
                          color: AppColor.error,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ).paddingOnly(top: 12),

                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                          onPressed: () => context.goToRegister(),
                          child: Text(
                            "Register Now",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
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
