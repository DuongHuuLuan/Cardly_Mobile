import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/data/datasources/local/auth_local_data_source.dart';
import 'package:cardly_app/data/datasources/remote/auth_remote_data_source.dart';
import 'package:cardly_app/domain/Entities/forgot-password/forgot_password_result.dart';
import 'package:cardly_app/domain/Entities/forgot-password/reset_password_result.dart';
import 'package:cardly_app/domain/Entities/forgot-password/verify_otp_result.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';
import 'package:cardly_app/domain/entities/auth_tokens.dart';
import 'package:cardly_app/domain/entities/forgot-password/resend_otp_result.dart';
import 'package:cardly_app/domain/entities/forgot-password/verify_reset_otp_result.dart';
import 'package:cardly_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthTokens>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await remoteDataSource.login(email, password);
      return Right(
        AuthTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
          tokenType: response.tokenType,
          expiresIn: response.expiresIn,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final user = await remoteDataSource.getProfile();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> register(UserEntity user) async {
    try {
      await remoteDataSource.register(user);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    try {
      final refreshToken = await localDataSource.getRefreshToken();
      if (refreshToken == null) return Left(CacheFailure("No refresh token"));

      final response = await remoteDataSource.refreshToken(refreshToken);
      await localDataSource.saveToken(response.accessToken);
      await localDataSource.saveRefreshToken(response.refreshToken);
      return Right(response.accessToken);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final refreshToken = await localDataSource.getRefreshToken();
      if (refreshToken != null) {
        await remoteDataSource.logout(refreshToken);
      }
      await localDataSource.clear();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getUser();
      if (user != null) {
        return Right(user);
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ForgotPasswordResult>> forgotPassword(
    String email,
  ) async {
    try {
      final result = await remoteDataSource.forgotPassword(email);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, VerifyOtpResult>> verifyOtp(
    String email,
    String otp,
  ) async {
    try {
      final result = await remoteDataSource.verifyOtp(email, otp);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, VerifyResetOtpResult>> verifyResetOtp(
    String email,
    String otp,
  ) async {
    try {
      final result = await remoteDataSource.verifyResetOtp(email, otp);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ResendOtpResult>> resendOtp(String email) async {
    try {
      final result = await remoteDataSource.resenOtp(email);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ResetPasswordResult>> resetPassword(
    String resetToken,
    String newPassword,
  ) async {
    try {
      final result = await remoteDataSource.resetPassword(
        resetToken,
        newPassword,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
