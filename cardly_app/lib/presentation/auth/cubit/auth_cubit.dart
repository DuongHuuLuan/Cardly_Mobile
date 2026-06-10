import 'dart:async';

import 'package:cardly_app/data/datasources/local/auth_local_data_source.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';
import 'package:cardly_app/domain/usecase/auth/forgot-password/forgot_password_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/forgot-password/resend_otp_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/forgot-password/reset_password_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/forgot-password/verify_otp_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/forgot-password/verify_reset_otp_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/get_current_user_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/get_profile_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/login_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/logout_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/register_usecase.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthLocalDataSource localStorage;
  final LoginUsecase loginUsecase;
  final GetProfileUsecase getProfileUsecase;
  final RegisterUsecase registerUsecase;
  final LogoutUsecase logoutUsecase;
  final GetCurrentUserUsecase getCurrentUserUsecase;
  final ForgotPasswordUsecase forgotPasswordUsecase;
  final VerifyOtpUsecase verifyOtpUsecase;
  final ResendOtpUsecase resendOtpUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;
  final VerifyResetOtpUsecase verifyResetOtpUsecase;

  Timer? _lockoutTimer;

  AuthCubit({
    required this.loginUsecase,
    required this.getProfileUsecase,
    required this.localStorage,
    required this.registerUsecase,
    required this.logoutUsecase,
    required this.getCurrentUserUsecase,
    required this.forgotPasswordUsecase,
    required this.verifyOtpUsecase,
    required this.resendOtpUsecase,
    required this.resetPasswordUsecase,
    required this.verifyResetOtpUsecase,
  }) : super(const AuthState());

  @override
  Future<void> close() {
    _lockoutTimer?.cancel();
    return super.close();
  }

  void clearEmailError() {
    if (state.emailError != null) {
      emit(state.copyWith(emailError: null));
    }
  }

  void clearPasswordError() {
    if (state.passwordError != null) {
      emit(state.copyWith(passwordError: null));
    }
  }

  Future<void> resetStatus() async {
    emit(const AuthState());
  }

  Future<void> login(String email, String password) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        emailError: null,
        passwordError: null,
        errorMessage: null,
        failedAttempts: state.lockoutSeconds > 0
            ? state.failedAttempts
            : state.failedAttempts,
      ),
    );
    final result = await loginUsecase(email, password);

    result.fold(
      (failure) {
        final newFailed = state.lockoutSeconds > 0
            ? state.failedAttempts
            : state.failedAttempts + 1;
        final lockout = newFailed >= 5 ? 60 : 0;

        emit(
          state.copyWith(
            status: AuthStatus.failed,
            emailError: failure.message == "Incorrect Email"
                ? failure.message
                : null,
            passwordError: failure.message == "Incorrect Password"
                ? failure.message
                : null,
            errorMessage: failure.message,
            failedAttempts: lockout > 0 ? 5 : newFailed,
            lockoutSeconds: lockout,
          ),
        );
        if (lockout > 0) {
          _startLockoutTimer();
        }
      },
      (tokens) async {
        _lockoutTimer?.cancel();
        await localStorage.saveToken(tokens.accessToken);
        await localStorage.saveRefreshToken(tokens.refreshToken);
        final profileResult = await getProfileUsecase();
        profileResult.fold(
          (failure) => emit(
            state.copyWith(
              status: AuthStatus.failed,
              errorMessage: failure.message,
            ),
          ),
          (user) async {
            await localStorage.saveUser(user);
            emit(
              state.copyWith(
                status: AuthStatus.authenticated,
                user: user,
                failedAttempts: 0,
                lockoutSeconds: 0,
              ),
            );
          },
        );
      },
    );
  }

  void _startLockoutTimer() {
    _lockoutTimer?.cancel();
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.lockoutSeconds - 1;
      if (remaining <= 0) {
        timer.cancel();
        emit(state.copyWith(lockoutSeconds: 0));
      } else {
        emit(state.copyWith(lockoutSeconds: remaining));
      }
    });
  }

  Future<void> register(UserEntity user) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        emailError: null,
        passwordError: null,
      ),
    );
    final result = await registerUsecase(user);

    result.fold(
      (failure) {
        final isEmailError = failure.message.contains(
          "already been registered",
        );
        emit(
          state.copyWith(
            status: AuthStatus.failed,
            emailError: isEmailError ? failure.message : null,
            errorMessage: isEmailError ? null : failure.message,
          ),
        );
      },
      (_) async {
        emit(
          state.copyWith(
            status: AuthStatus.registrationSuccess,
            email: user.email,
          ),
        );
      },
    );
  }

  Future<void> resendRegisterOtp(UserEntity user) async {
    await resendOtp(user.email);
  }

  Future<void> getUser() async {
    final result = await getCurrentUserUsecase();

    result.fold(
      (failure) => emit(state.copyWith(status: AuthStatus.unauthenticated)),
      (user) {
        if (user != null) {
          emit(state.copyWith(status: AuthStatus.authenticated, user: user));
        } else {
          emit(state.copyWith(status: AuthStatus.unauthenticated));
        }
      },
    );
  }

  Future<void> updateUser(UserEntity updatedUser) async {
    await localStorage.saveUser(updatedUser);
    emit(state.copyWith(status: AuthStatus.authenticated, user: updatedUser));
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await logoutUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failed,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: AuthStatus.unauthenticated)),
    );
  }

  Future<void> forgotPassword(String email) async {
    emit(state.copyWith(status: AuthStatus.forgotPasswordLoading));
    final result = await forgotPasswordUsecase(email);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.forgotPasswordFailure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: AuthStatus.forgotPasswordSuccess)),
    );
  }

  Future<void> verifyOtp(String email, String otp, {String? password}) async {
    emit(state.copyWith(status: AuthStatus.verifyOtpLoading));
    final result = await verifyOtpUsecase(email, otp);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.verifyOtpFailure,
          errorMessage: failure.message,
        ),
      ),
      (_) async {
        if (password != null) {
          final loginResult = await loginUsecase(email, password);
          loginResult.fold(
            (failure) => emit(
              state.copyWith(
                status: AuthStatus.failed,
                errorMessage: failure.message,
              ),
            ),
            (tokens) async {
              await localStorage.saveToken(tokens.accessToken);
              await localStorage.saveRefreshToken(tokens.refreshToken);
              final profileResult = await getProfileUsecase();
              profileResult.fold(
                (failure) => emit(
                  state.copyWith(
                    status: AuthStatus.failed,
                    errorMessage: failure.message,
                  ),
                ),
                (user) async {
                  await localStorage.saveUser(user);
                  emit(
                    state.copyWith(
                      status: AuthStatus.authenticated,
                      user: user,
                      failedAttempts: 0,
                      lockoutSeconds: 0,
                    ),
                  );
                },
              );
            },
          );
        } else {
          emit(state.copyWith(status: AuthStatus.verifyOtpSuccess));
        }
      },
    );
  }

  Future<void> verifyResetOtp(String email, String otp) async {
    emit(state.copyWith(status: AuthStatus.verifyResetOtpLoading));
    final result = await verifyResetOtpUsecase(email, otp);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.verifyResetOtpFailure,
            errorMessage: failure.message,
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            status: AuthStatus.verifyResetOtpSuccess,
            resetToken: data.reset_token,
          ),
        );
      },
    );
  }

  Future<void> resendOtp(String email) async {
    emit(state.copyWith(status: AuthStatus.resendOtpLoading));
    final result = await resendOtpUsecase(email);

    result.fold((failure) {
      emit(
        state.copyWith(
          status: AuthStatus.resendOtpFailure,
          errorMessage: failure.message,
        ),
      );
    }, (_) => emit(state.copyWith(status: AuthStatus.resendOtpSuccess)));
  }

  Future<void> resetPassword(String resetToken, String newPassword) async {
    emit(state.copyWith(status: AuthStatus.resetPasswordLoading));
    final result = await resetPasswordUsecase(resetToken, newPassword);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.resetPasswordFailure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: AuthStatus.resetPasswordSuccess)),
    );
  }
}
