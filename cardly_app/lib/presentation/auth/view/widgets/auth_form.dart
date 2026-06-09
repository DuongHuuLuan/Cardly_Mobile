import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/widgets/app_password_text_form_field.dart';
import 'package:cardly_app/core/widgets/app_text_form_field.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController? nameController;
  final TextEditingController? emailController;
  final TextEditingController? phoneController;
  final TextEditingController? passwordController;
  final TextEditingController? confirmPasswordController;
  final String? emailError;
  final String? passwordError;

  const AuthForm({
    super.key,
    required this.formKey,
    this.nameController,
    this.emailController,
    this.phoneController,
    this.passwordController,
    this.confirmPasswordController,
    this.emailError,
    this.passwordError,
  });
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          if (nameController != null) ...[
            AppTextFormField(
              controller: nameController!,
              labelText: "Name",
              hintText: "Enter Name",
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 20),
          ],
          if (emailController != null) ...[
            AppTextFormField(
              controller: emailController!,
              labelText: "Email Address",
              hintText: "Enter Email",
              prefixIcon: Icons.email_outlined,
            ),
            if (emailError != null) ...[
              const SizedBox(height: 4),
              Text(
                emailError!,
                style: const TextStyle(color: AppColor.error, fontSize: 12),
              ),
            ],
            const SizedBox(height: 20),
          ],
          if (phoneController != null) ...[
            AppTextFormField(
              controller: phoneController!,
              labelText: "Mobile Number",
              hintText: "Enter Mobile Number",
              prefixIcon: Icons.phone_outlined,
            ),
            const SizedBox(height: 20),
          ],

          if (passwordController != null) ...[
            AppPasswordTextFormField(
              controller: passwordController!,
              labelText: "Password",
              hintText: "Enter Password",
            ),
            if (passwordError != null) ...[
              const SizedBox(height: 4),
              Text(
                passwordError!,
                style: const TextStyle(color: AppColor.error, fontSize: 12),
              ),
            ],
            const SizedBox(height: 20),
          ],
          if (confirmPasswordController != null) ...[
            AppPasswordTextFormField(
              controller: confirmPasswordController!,
              labelText: "Confirm Password",
              hintText: "Confirm Password",
            ),
          ],
        ],
      ),
    );
  }
}
