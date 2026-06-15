import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/user_entity.dart';
import 'package:cardly_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase({required this.repository});

  Future<Either<Failure, void>> call(UserEntity user) async {
    return await repository.register(user);
  }
}
