import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/repositories/contact_repository.dart';
import 'package:dartz/dartz.dart';

class SyncContactsUsecase {
  final ContactRepository repository;

  SyncContactsUsecase({required this.repository});

  Future<Either<Failure, void>> call() => repository.syncContacts();
}
