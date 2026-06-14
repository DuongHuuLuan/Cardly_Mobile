import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/user_entity.dart';
import 'package:cardly_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class GetProfileUsecase {
  final AuthRepository repository;
  GetProfileUsecase({required this.repository});

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getProfile();
  }
}
