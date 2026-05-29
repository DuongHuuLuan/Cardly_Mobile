import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/repositories/contact_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteContactUsecase {
  final ContactRepository repository;

  DeleteContactUsecase({required this.repository});

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteContact(id);
  }
}
