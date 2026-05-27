import 'dart:async';

import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/widgets/app_alert_dialog.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:cardly_app/presentation/auth/forgot-password/forgot_password_screen.dart';
import 'package:cardly_app/presentation/auth/forgot-password/reset_password_screen.dart';
import 'package:cardly_app/presentation/auth/forgot-password/widgets/otp_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

extension OtpVerificationNavigation on BuildContext {
  void goToOtpVerification() => go('/verify-otp');
}

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late final AuthCubit _authCubit;
  late String _email;
  String _otp = '';
  final GlobalKey<OtpInputFieldState> _otpFieldKey =
      GlobalKey<OtpInputFieldState>();
  Timer? _timer;
  int _remainingSeconds = 300;

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _email = GoRouterState.of(context).extra as String;
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 300;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
        showDialog(
          context: context,
          builder: (context) => AppAlertDialog(
            title: "OTP code has expired",
            message: "Please request a new OTP code.",
            buttonLabel: "Re-sen OTP",
            onConfirm: () {
              Navigator.pop(context);
              _authCubit.forgotPassword(_email);
              _startTimer();
            },
          ),
        );
      }
    });
  }

  void _handleOtpCompleted(String otp) {
    setState(() => _otp = otp);
  }

  void _handleVerifyFailure() {
    // _authCubit.resetStatus();
    // setState(() => _otp = '');
    // _otpFieldKey.currentState?.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AppAlertDialog(
        title: "Incorrect OTP code",
        onConfirm: () => Navigator.pop(ctx),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.goToForgotPassword(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == AuthStatus.verifyOtpSuccess) {
            context.goToResetPassword(_email);
          } else if (state.status == AuthStatus.verifyOtpFailure) {
            _handleVerifyFailure();
          }
        },
        builder: (context, state) {
          final isLoading = state.status == AuthStatus.verifyOtpLoading;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Enter OTP Code",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "OTP code has been sent to your email",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColor.greyDark,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 40),
                OtpInputField(
                  key: _otpFieldKey,
                  length: 6,
                  onCompleted: (otp) => setState(() => _otp = otp),
                ),
                const SizedBox(height: 20),

                Center(
                  child: _remainingSeconds > 0
                      ? Text(
                          "Resend code ${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}",
                          style: const TextStyle(color: AppColor.greyDark),
                        )
                      : GestureDetector(
                          onTap: () {
                            _authCubit.forgotPassword(_email);
                            _startTimer();
                          },
                          child: const Text(
                            "Re-send OTP",
                            style: TextStyle(
                              color: AppColor.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 40),
                AppElevatedButton(
                  label: "Confirm",
                  onPressed: _otp.length == 6
                      ? () => _authCubit.verifyOtp(_email, _otp)
                      : null,
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
