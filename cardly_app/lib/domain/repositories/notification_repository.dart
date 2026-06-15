import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/notification/notification_entity.dart';
import 'package:dartz/dartz.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, void>> markAsRead(String id);
  Future<Either<Failure, void>> delete(String id);
  Future<Either<Failure, void>> registerToken(String token);
  Future<Either<Failure, void>> getFcmToken();
  Future<Either<Failure, String>> onTokenRefresh();
}
