import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:cardly_app/domain/repositories/contact_repository.dart';
import 'package:dartz/dartz.dart';

class GetContactByIdUsecase {
  final ContactRepository repository;
  GetContactByIdUsecase({required this.repository});

  Future<Either<Failure, BusinessCardEntity>> call(String id) async {
    return await repository.getContactById(id);
  }
}
