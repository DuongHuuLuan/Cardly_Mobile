import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class OnTokenRefreshUsecase {
  final NotificationRepository repository;

  OnTokenRefreshUsecase({required this.repository});

  Future<Either<Failure, String>> call() async {
    return await repository.onTokenRefresh();
  }
}
