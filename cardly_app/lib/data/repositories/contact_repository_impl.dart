import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/data/datasources/local/auth_local_data_source.dart';
import 'package:cardly_app/data/datasources/local/contact_local_data_source.dart';
import 'package:cardly_app/data/datasources/remote/contact_remote_data_source.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:cardly_app/domain/repositories/contact_repository.dart';
import 'package:dartz/dartz.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource remoteDataSource;
  final ContactLocalDataSource localDataSource;
  final AuthLocalDataSource authLocalDataSource;

  ContactRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.authLocalDataSource,
  });

  Future<String?> get _userId async =>
      (await authLocalDataSource.getUser())?.id;

  @override
  Future<Either<Failure, List<BusinessCardEntity>>> getContacts() async {
    try {
      final userId = await _userId;
      if (userId == null) return Left(CacheFailure('User not logged in'));
      final local = await localDataSource.getContacts(userId);
      try {
        final remote = await remoteDataSource.getContacts();
        await localDataSource.cacheContacts(remote);
        return Right(remote);
      } on ServerException {
        return Right(local);
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BusinessCardEntity>> saveContact(
    BusinessCardEntity contact,
  ) async {
    try {
      final userId = await _userId;
      if (userId == null) return Left(CacheFailure('User not logged in'));
      final local = await localDataSource.saveContact(contact, userId);
      try {
        final remote = await remoteDataSource.saveContact(contact);
        return Right(remote);
      } on ServerException {
        return Right(local);
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteContact(String id) async {
    try {
      await localDataSource.deleteContact(id);
      try {
        await remoteDataSource.deleteContact(id);
        return const Right(null);
      } on ServerException {
        return Right(null);
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
