import 'package:cardly_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  final List<TextEditingController> controllers;
  final VoidCallback onPressed;
  final String label;
  final bool isLoading;
  final bool canSubmit;

  const SubmitButton({
    super.key,
    required this.controllers,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.canSubmit = true,
  });

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  void initState() {
    super.initState();
    for (final c in widget.controllers) {
      c.addListener(_onChanged);
    }
  }

  @override
  void didUpdateWidget(SubmitButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controllers != widget.controllers) {
      for (final c in oldWidget.controllers) {
        c.removeListener(_onChanged);
      }
      for (final c in widget.controllers) {
        c.addListener(_onChanged);
      }
    }
  }

  @override
  void dispose() {
    for (final c in widget.controllers) {
      c.removeListener(_onChanged);
    }
    super.dispose();
  }

  void _onChanged() => setState(() {});

  bool get _isFilled => widget.controllers.every((c) => c.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: (_isFilled && widget.canSubmit)
              ? AppColor.primary
              : AppColor.greyLight,
          foregroundColor: (_isFilled && widget.canSubmit)
              ? AppColor.white
              : AppColor.greyDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: (_isFilled && widget.canSubmit && !widget.isLoading)
            ? widget.onPressed
            : null,
        child: widget.isLoading
            ? const CircularProgressIndicator(color: AppColor.white)
            : Text(widget.label),
      ),
    );
  }
}
