import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/widgets/app_text_form_field.dart';
import 'package:flutter/material.dart';

class AppPasswordTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;

  const AppPasswordTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.validator,
  });

  @override
  State<AppPasswordTextFormField> createState() =>
      _AppPasswordTextFormFieldState();
}

class _AppPasswordTextFormFieldState extends State<AppPasswordTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      prefixIcon: Icons.lock_outline,
      obscureText: _obscureText,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColor.greyLight,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
      validator: widget.validator,
    );
  }
}
