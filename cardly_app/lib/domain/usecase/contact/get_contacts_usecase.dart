import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:cardly_app/domain/repositories/contact_repository.dart';
import 'package:dartz/dartz.dart';

class GetContactsUsecase {
  final ContactRepository repository;

  GetContactsUsecase({required this.repository});

  Future<Either<Failure, List<BusinessCardEntity>>> call() async {
    return await repository.getContacts();
  }
}
