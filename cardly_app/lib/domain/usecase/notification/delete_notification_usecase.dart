import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteNotificationUsecase {
  final NotificationRepository repository;
  DeleteNotificationUsecase(this.repository);

  Future<Either<Failure, void>> call(String id) => repository.delete(id);
}
