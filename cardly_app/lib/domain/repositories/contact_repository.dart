import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:dartz/dartz.dart';

import '../entities/paginated_result.dart';

abstract class ContactRepository {
  Future<Either<Failure, List<BusinessCardEntity>>> getContacts();
  Future<Either<Failure, BusinessCardEntity>> getContactById(String id);
  Future<Either<Failure, BusinessCardEntity>> saveContact(
    BusinessCardEntity contact,
  );
  Future<Either<Failure, void>> deleteContact(String id);

  Future<Either<Failure, void>> syncContacts();
  Future<Either<Failure, PaginatedResult>> getContactsPaginated(
    int offset,
    int limit,
  );
}
