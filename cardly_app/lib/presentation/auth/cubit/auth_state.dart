import 'package:equatable/equatable.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';

const _nullValue = Object();

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  failed,
  registrationSuccess,
  forgotPasswordLoading,
  forgotPasswordSuccess,
  forgotPasswordFailure,

  verifyOtpLoading,
  verifyOtpSuccess,
  verifyOtpFailure,

  verifyResetOtpLoading,
  verifyResetOtpSuccess,
  verifyResetOtpFailure,

  resendOtpLoading,
  resendOtpSuccess,
  resendOtpFailure,

  resetPasswordLoading,
  resetPasswordSuccess,
  resetPasswordFailure,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final String? successMessage;
  final String? nextStep;
  final String? emailError;
  final String? passwordError;
  final String? email;
  final int failedAttempts;
  final int lockoutSeconds;
  final String? resetToken;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.nextStep,
    this.successMessage,
    this.emailError,
    this.passwordError,
    this.email,
    this.failedAttempts = 0,
    this.lockoutSeconds = 0,
    this.resetToken,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
    String? successMessage,
    String? nextStep,
    Object? emailError = _nullValue,
    Object? passwordError = _nullValue,
    Object? email = _nullValue,
    int? failedAttempts,
    int? lockoutSeconds,
    Object? resetToken = _nullValue,
  }) => AuthState(
    status: status ?? this.status,
    user: user ?? this.user,
    successMessage: successMessage ?? this.successMessage,
    errorMessage: errorMessage ?? this.errorMessage,
    nextStep: nextStep ?? this.nextStep,
    emailError: identical(emailError, _nullValue)
        ? this.emailError
        : emailError as String?,
    passwordError: identical(passwordError, _nullValue)
        ? this.passwordError
        : passwordError as String?,
    email: identical(email, _nullValue) ? this.email : email as String?,
    failedAttempts: failedAttempts ?? this.failedAttempts,
    lockoutSeconds: lockoutSeconds ?? this.lockoutSeconds,
    resetToken: identical(resetToken, _nullValue)
        ? this.resetToken
        : resetToken as String?,
  );

  @override
  List<Object?> get props => [
    status,
    user,
    successMessage,
    errorMessage,
    nextStep,
    emailError,
    passwordError,
    email,
    failedAttempts,
    lockoutSeconds,
    resetToken,
  ];
}
