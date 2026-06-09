import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase({required this.repository});

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
