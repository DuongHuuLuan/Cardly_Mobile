import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/data/datasources/remote/contact_remote_data_source.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:cardly_app/domain/repositories/contact_repository.dart';
import 'package:dartz/dartz.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource remoteDataSource;

  ContactRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BusinessCardEntity>>> getContacts() async {
    try {
      final contacts = await remoteDataSource.getContacts();
      return Right(contacts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, BusinessCardEntity>> saveContact(
    BusinessCardEntity contact,
  ) async {
    try {
      final saved = await remoteDataSource.saveContact(contact);
      return Right(saved);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteContact(String id) async {
    try {
      await remoteDataSource.deleteContact(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
