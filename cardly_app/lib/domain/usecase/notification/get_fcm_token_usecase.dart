import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class GetFcmTokenUsecase {
  final NotificationRepository repository;

  GetFcmTokenUsecase({required this.repository});

  Future<Either<Failure, void>> call() async {
    return await repository.getFcmToken();
  }
}
