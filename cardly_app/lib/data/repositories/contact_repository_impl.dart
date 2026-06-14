import 'package:cardly_app/core/enums/sync_status.dart';
import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/core/utils/sync_helper.dart';
import 'package:cardly_app/data/datasources/local/auth_local_data_source.dart';
import 'package:cardly_app/data/datasources/local/contact_local_data_source.dart';
import 'package:cardly_app/data/datasources/remote/contact_remote_data_source.dart';
import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:cardly_app/domain/entities/paginated_result.dart';
import 'package:cardly_app/domain/repositories/contact_repository.dart';
import 'package:dartz/dartz.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource remoteDataSource;
  final ContactLocalDataSource localDataSource;
  final AuthLocalDataSource authLocalDataSource;

  ContactRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.authLocalDataSource,
  });

  Future<String?> get _userId async =>
      (await authLocalDataSource.getUser())?.id;

  @override
  Future<Either<Failure, List<BusinessCardEntity>>> getContacts() async {
    try {
      final userId = await _userId;
      if (userId == null) return Left(CacheFailure('User not logged in'));
      final local = await localDataSource.getContacts(userId);
      try {
        final remoteList = await remoteDataSource.getContacts(0, 1000);
        final details = <BusinessCardEntity>[];
        for (final item in remoteList.items) {
          try {
            final detail = await remoteDataSource.getContactDetail(
              item.processingId,
            );
            details.add(SyncHelper.mapDetailToEntity(detail));
          } catch (_) {}
        }
        if (details.isNotEmpty) {
          await localDataSource.cacheContacts(details);
          return Right(details);
        }
        return Right(local);
      } on ServerException {
        return Right(local);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, BusinessCardEntity>> getContactById(String id) async {
    try {
      final contact = await localDataSource.findById(id);
      if (contact == null) return Left(CacheFailure('Contact not found'));
      return Right(contact);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, BusinessCardEntity>> saveContact(
    BusinessCardEntity contact,
  ) async {
    try {
      final userId = await _userId;
      if (userId == null) return Left(CacheFailure('User not logged in'));

      final toSave = contact.copyWith(syncStatus: SyncStatus.pendingCreate);
      final local = await localDataSource.saveContact(toSave, userId);

      try {
        final remote = await remoteDataSource.saveContact(contact);
        // Remote thành công → update sync_status
        await localDataSource.updateSyncStatus(local.id!, SyncStatus.synced);
        if (remote.processingId != null) {
          await localDataSource.updateProcessingId(
            local.id!,
            remote.processingId!,
          );
        }
        return Right(remote.copyWith(id: local.id));
      } on ServerException {
        return Right(local);
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteContact(String id) async {
    try {
      final userId = await _userId;
      if (userId == null) return Left(CacheFailure('User not logged in'));

      final contacts = await localDataSource.getContacts(userId);
      final contact = contacts.where((c) => c.id == id).firstOrNull;

      if (contact == null) {
        return Left(CacheFailure('Contact not found'));
      }

      switch (contact.syncStatus) {
        case SyncStatus.synced:
          if (contact.processingId != null) {
            // Xoá server trước
            await remoteDataSource.deleteContact(contact.processingId!);
          }
          // xóa local
          await localDataSource.deleteContact(id);
        case SyncStatus.pendingCreate:
          // Server chưa biết đến contact này → chỉ xoá local
          await remoteDataSource.deleteContact(
            contact.processingId!,
          ); //// đang bị lỗi chổ này ( trạng thái bị lỗi là pendingCreate đúng phải là synced
          await localDataSource.deleteContact(id);
        case SyncStatus.pendingUpdate:
        case SyncStatus.pendingDelete:
          // Đánh dấu pendingDelete, sync sau sẽ push delete
          await localDataSource.updateSyncStatus(id, SyncStatus.pendingDelete);
      }
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncContacts() async {
    try {
      final userId = await _userId;
      if (userId == null) return Left(CacheFailure('User not logged in'));

      // 1. Push local pending
      final pending = await localDataSource.getPendingSync(userId);
      for (final contact in pending) {
        try {
          switch (contact.syncStatus) {
            case SyncStatus.pendingCreate:
              final saved = await remoteDataSource.saveContact(contact);
              await localDataSource.updateSyncStatus(
                contact.id!,
                SyncStatus.synced,
              );
              if (saved.processingId != null) {
                await localDataSource.updateProcessingId(
                  contact.id!,
                  saved.processingId!,
                );
              }
            case SyncStatus.pendingUpdate:
              await remoteDataSource.updateContact(contact);
              await localDataSource.updateSyncStatus(
                contact.id!,
                SyncStatus.synced,
              );
            case SyncStatus.pendingDelete:
              if (contact.processingId != null) {
                await remoteDataSource.deleteContact(contact.processingId!);
              }
              await localDataSource.deleteContact(contact.id!);
            default:
              break;
          }
        } catch (_) {
          // Bỏ qua, lần sync sau sẽ thử lại
        }
      }

      // 2. Pull server changes
      var skip = 0;
      const limit = 20;
      var hasMore = true;

      while (hasMore) {
        final docList = await remoteDataSource.getContacts(skip, limit);
        for (final item in docList.items) {
          try {
            final detail = await remoteDataSource.getContactDetail(
              item.processingId,
            );
            final existing = await localDataSource.findByProcessingId(
              item.processingId,
            );

            if (existing == null) {
              // Server mới → insert local
              final entity = SyncHelper.mapDetailToEntity(detail);
              await localDataSource.saveContact(entity, userId);
            } else if (existing.syncStatus == SyncStatus.synced) {
              // Server đã thay đổi → update local
              final serverTime = DateTime.tryParse(item.uploadedAt);
              if (serverTime != null &&
                  (existing.uploadedAt == null ||
                      serverTime.isAfter(existing.uploadedAt!))) {
                final updated = SyncHelper.mapDetailToEntity(
                  detail,
                  localId: existing.id,
                  localCreatedAt: existing.createdAt,
                ).copyWith(uploadedAt: serverTime);
                await localDataSource.saveContact(updated, userId);
              }
            }
            // Nếu local có pending → giữ nguyên, không overwrite
          } catch (_) {}
        }

        skip += limit;
        hasMore = skip < docList.total;
      }

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResult>> getContactsPaginated(
    int offset,
    int limit,
  ) async {
    try {
      final userId = await _userId;
      if (userId == null) {
        return Left(CacheFailure('User not logged in'));
      }
      final result = await localDataSource.getContactsPaginated(
        userId,
        offset: offset,
        limit: limit,
      );
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
