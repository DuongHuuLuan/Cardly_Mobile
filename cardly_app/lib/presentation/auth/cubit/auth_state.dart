import 'package:equatable/equatable.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';

const _nullValue = Object();

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  failed,
  forgotPasswordLoading,
  forgotPasswordSuccess,
  forgotPasswordFailure,

  verifyOtpLoading,
  verifyOtpSuccess,
  verifyOtpFailure,

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
  final int failedAttempts;
  final int lockoutSeconds;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.nextStep,
    this.successMessage,
    this.emailError,
    this.passwordError,
    this.failedAttempts = 0,
    this.lockoutSeconds = 0,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
    String? successMessage,
    String? nextStep,
    Object? emailError = _nullValue,
    Object? passwordError = _nullValue,
    int? failedAttempts,
    int? lockoutSeconds,
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
    failedAttempts: failedAttempts ?? this.failedAttempts,
    lockoutSeconds: lockoutSeconds ?? this.lockoutSeconds,
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
    failedAttempts,
    lockoutSeconds,
  ];
}
