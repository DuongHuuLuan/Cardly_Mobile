import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:flutter/material.dart';

class PasswordStrengthWidget extends StatefulWidget {
  final TextEditingController passwordController;
  final ValueChanged<bool>? onStrengthChanged;
  const PasswordStrengthWidget({
    super.key,
    required this.passwordController,
    this.onStrengthChanged,
  });
  @override
  State<PasswordStrengthWidget> createState() => _PasswordStrengthWidgetState();
}

class _PasswordStrengthWidgetState extends State<PasswordStrengthWidget> {
  final _checks = [false, false, false, false, true];
  static const _messages = [
    "Minimum 8 characters",
    "At least 1 uppercase letter",
    "At least 1 digit",
    "At least 1 special character",
    "No spaces",
  ];
  int get _passedCount => _checks.where((v) => v).length;
  bool get _isValid => _passedCount == 5;
  @override
  void initState() {
    super.initState();
    widget.passwordController.addListener(_validate);
  }

  @override
  void dispose() {
    widget.passwordController.removeListener(_validate);
    super.dispose();
  }

  void _validate() {
    final pwd = widget.passwordController.text;
    setState(() {
      _checks[0] = pwd.length >= 8;
      _checks[1] = pwd.contains(RegExp(r'[A-Z]'));
      _checks[2] = pwd.contains(RegExp(r'[0-9]'));
      _checks[3] = pwd.contains(
        RegExp(r'[!@#$%^&*(),.?":{}|<>~`_\-+=\[\]\\;/]'),
      );
      _checks[4] = !pwd.contains(' ');
    });
    widget.onStrengthChanged?.call(_isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(_messages.length, (i) {
          final passed = _checks[i];
          return Row(
            children: [
              Icon(
                passed ? Icons.check_circle : Icons.cancel,
                size: 16,
                color: passed ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 6),
              Text(
                _messages[i],
                style: TextStyle(
                  fontSize: 12,
                  color: passed ? Colors.green : Colors.red,
                ),
              ),
            ],
          ).paddingOnly(bottom: 4);
        }),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _passedCount / 5,
            minHeight: 6,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              _passedCount <= 1
                  ? Colors.red
                  : _passedCount <= 3
                  ? Colors.orange
                  : Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}
