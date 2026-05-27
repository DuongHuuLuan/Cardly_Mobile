import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/widgets/submit_button.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:cardly_app/presentation/auth/view/login_screen.dart';
import 'package:cardly_app/presentation/auth/view/widgets/auth_form.dart';
import 'package:cardly_app/presentation/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

extension RegisterNavigation on BuildContext {
  void goToRegister() => go('/register');
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final AuthCubit _authCubit;

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
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
        id: DateTime.now().microsecondsSinceEpoch,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
      );

      _authCubit.register(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.failed &&
                  state.errorMessage != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              }

              if (state.status == AuthStatus.authenticated) {
                context.goToHome();
              }
            },
          ),
        ],
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  Text(
                    "Sign Up",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  Text(
                    "Enter your information below",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColor.grey),
                  ),
                  const SizedBox(height: 30),

                  AuthForm(
                    formKey: _formKey,
                    nameController: nameController,
                    emailController: emailController,
                    phoneController: phoneController,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                  ),

                  const SizedBox(height: 30),
                  SubmitButton(
                    controllers: [
                      nameController,
                      emailController,
                      phoneController,
                      passwordController,
                      confirmPasswordController,
                    ],
                    onPressed: () => _register(),
                    label: "Register",
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
        ),
      ),
    );
  }
}
