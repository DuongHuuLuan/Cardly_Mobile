import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ContactRepository {
  Future<Either<Failure, List<BusinessCardEntity>>> getContacts();
  Future<Either<Failure, BusinessCardEntity>> saveContact(
    BusinessCardEntity contact,
  );
  Future<Either<Failure, void>> deleteContact(String id);
}
