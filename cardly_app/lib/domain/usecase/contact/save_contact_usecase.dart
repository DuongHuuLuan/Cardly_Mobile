import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:cardly_app/domain/repositories/contact_repository.dart';
import 'package:dartz/dartz.dart';

class SaveContactUsecase {
  final ContactRepository repository;

  SaveContactUsecase({required this.repository});

  Future<Either<Failure, BusinessCardEntity>> call(
    BusinessCardEntity contact,
  ) async {
    return await repository.saveContact(contact);
  }
}
