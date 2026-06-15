import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/repositories/contact_repository.dart';
import 'package:dartz/dartz.dart';

import '../../entities/paginated_result.dart';

class GetContactsPaginatedUsecase {
  final ContactRepository repository;
  GetContactsPaginatedUsecase({required this.repository});

  Future<Either<Failure, PaginatedResult>> call(int offset, int limit) async {
    return await repository.getContactsPaginated(offset, limit);
  }
}
