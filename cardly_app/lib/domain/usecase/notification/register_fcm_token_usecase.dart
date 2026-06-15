import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterFcmTokenUsecase {
  final NotificationRepository repository;
  RegisterFcmTokenUsecase(this.repository);

  Future<Either<Failure, void>> call(String token) =>
      repository.registerToken(token);
}
