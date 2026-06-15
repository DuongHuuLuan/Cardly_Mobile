import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/notification/notification_entity.dart';
import 'package:cardly_app/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class GetNotificationsUsecase {
  final NotificationRepository repository;

  GetNotificationsUsecase({required this.repository});

  Future<Either<Failure, List<NotificationEntity>>> call() async {
    return await repository.getNotifications();
  }
}
