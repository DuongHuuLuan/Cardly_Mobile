import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';
import 'package:cardly_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase({required this.repository});

  Future<Either<Failure, UserEntity>> call(
    String email,
    String password,
  ) async {
    return await repository.login(email, password);
  }
}
