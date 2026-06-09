import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/data/datasources/local/contact_local_data_source.dart';
import 'package:cardly_app/data/models/contact/contact_detail_response.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ContactRepository {
  Future<Either<Failure, List<BusinessCardEntity>>> getContacts();
  Future<Either<Failure, BusinessCardEntity>> saveContact(
    BusinessCardEntity contact,
  );
  Future<ContactDetailResponse> getContactDetail(String processingId);
  Future<Either<Failure, void>> deleteContact(String id);

  Future<Either<Failure, void>> syncContacts();
  Future<Either<Failure, PaginatedResult>> getContactsPaginated(
    int offset,
    int limit,
  );
}
