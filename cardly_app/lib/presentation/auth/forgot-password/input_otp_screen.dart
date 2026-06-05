import 'dart:async';

import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/widgets/app_alert_dialog.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:cardly_app/presentation/auth/forgot-password/widgets/otp_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationScreen extends StatefulWidget {
  static const routerName = "/verify-otp";

  const OtpVerificationScreen({super.key});
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late final AuthCubit _authCubit;
  String _email = '';
  bool _isRegistration = false;
  UserEntity? _registrationUser;
  bool _initialized = false;

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
    if (!_initialized) {
      _initialized = true;
      final args = GoRouterState.of(context).extra as Map<String, dynamic>;
      _email = args['email'] as String;
      _isRegistration = args['isRegistration'] as bool;
      _registrationUser = args['user'] as UserEntity?;
    }
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
              _resendOtp();
              _startTimer();
            },
          ),
        );
      }
    });
  }

  void _resendOtp() {
    if (_isRegistration && _registrationUser != null) {
      _authCubit.resendRegisterOtp(_registrationUser!);
    } else {
      _authCubit.resendOtp(_email);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        onLeadingPressed: () {
          context.pop();
        },
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.goToHome();
          } else if (state.status == AuthStatus.verifyResetOtpSuccess &&
              !_isRegistration) {
            context.goToResetPassword(_email, state.resetToken!);
          } else if (state.status == AuthStatus.verifyOtpFailure) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => AppAlertDialog(
                title: "Incorrect OTP code",
                onConfirm: () => Navigator.pop(ctx),
              ),
            );
          } else if (state.status == AuthStatus.failed &&
              state.errorMessage != null) {
            showDialog(
              context: context,
              builder: (_) => AppAlertDialog(
                icon: Icons.error_outline,
                color: AppColor.error,
                title: "Login Failed",
                message: state.errorMessage,
                buttonLabel: "OK",
                onConfirm: () => Navigator.pop(context),
              ),
            );
          } else if (state.status == AuthStatus.verifyResetOtpFailure) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => AppAlertDialog(
                title: "Incorrect OTP code",
                message: state.errorMessage,
                onConfirm: () => Navigator.pop(ctx),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading =
              state.status == AuthStatus.verifyOtpLoading ||
              state.status == AuthStatus.verifyResetOtpLoading;
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
                            _resendOtp();
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
                      ? () {
                          if (_isRegistration) {
                            _authCubit.verifyOtp(
                              _email,
                              _otp,
                              password: _registrationUser?.password,
                            );
                          } else {
                            _authCubit.verifyResetOtp(_email, _otp);
                          }
                        }
                      : null,
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
