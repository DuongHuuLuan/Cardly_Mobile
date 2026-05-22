import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/data/datasources/local/auth_local_data_source.dart';
import 'package:cardly_app/data/datasources/remote/auth_remote_data_source.dart';
import 'package:cardly_app/data/mappers/user_mapper.dart';
import 'package:cardly_app/domain/Entities/user.dart';
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
  Future<Either<Failure, UserEntity>> login(
      String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      await localDataSource.saveToken(userModel.password ?? "");
      await localDataSource.saveUser(userModel);
      return Right(UserMapper.fromModel(userModel));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(UserEntity user) async {
    try {
      final userModel = UserMapper.toModel(user);
      final result = await remoteDataSource.register(userModel);
      return Right(UserMapper.fromModel(result));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clear();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getUser();
      if (userModel != null) {
        return Right(UserMapper.fromModel(userModel));
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
