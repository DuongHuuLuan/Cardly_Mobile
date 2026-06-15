import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class MarkNotificationReadUsecase {
  final NotificationRepository repository;
  MarkNotificationReadUsecase(this.repository);

  Future<Either<Failure, void>> call(String id) => repository.markAsRead(id);
}
