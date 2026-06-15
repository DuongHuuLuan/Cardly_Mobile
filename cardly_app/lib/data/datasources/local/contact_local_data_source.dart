import 'dart:convert';

import 'package:cardly_app/core/enums/sync_status.dart';
import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/data/datasources/local/database_helper.dart';
import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:cardly_app/domain/entities/paginated_result.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

abstract class ContactLocalDataSource {
  Future<List<BusinessCardEntity>> getContacts(String userId);
  Future<BusinessCardEntity?> findById(String id);

  Future<BusinessCardEntity> saveContact(
    BusinessCardEntity contact,
    String userId,
  );
  Future<void> deleteContact(String id);
  Future<void> cacheContacts(List<BusinessCardEntity> contacts);
  Future<void> updateProcessingId(String id, String processingId);
  Future<PaginatedResult> getContactsPaginated(
    String userId, {
    required int offset,
    required int limit,
  });

  Future<List<BusinessCardEntity>> getPendingSync(String userId);
  Future<void> updateSyncStatus(String id, SyncStatus status);

  Future<BusinessCardEntity?> findByProcessingId(String processingId);
}

class ContactLocalDataSourceImpl implements ContactLocalDataSource {
  final DatabaseHelper dbHelper;

  ContactLocalDataSourceImpl(this.dbHelper);

  @override
  Future<List<BusinessCardEntity>> getContacts(String userId) async {
    try {
      final db = await dbHelper.database;
      final rows = await db.query(
        'business_cards',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
      return rows.map(_rowToEntity).toList();
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<BusinessCardEntity?> findById(String id) async {
    final db = await dbHelper.database;
    final rows = await db.query(
      'business_cards',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _rowToEntity(rows.first);
  }

  @override
  Future<BusinessCardEntity> saveContact(
    BusinessCardEntity contact,
    String userId,
  ) async {
    try {
      final db = await dbHelper.database;
      final id = contact.id ?? const Uuid().v4();
      final now = DateTime.now().toIso8601String();
      final row = _entityToRow(
        contact.copyWith(
          id: id,
          userId: userId,
          createdAt: contact.createdAt ?? DateTime.tryParse(now),
        ),
        now,
      );
      await db.insert('business_cards', {
        ...row,
        'created_at': now,
        'updated_at': now,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      return contact.copyWith(
        id: id,
        userId: userId,
        createdAt: DateTime.tryParse(now),
      );
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> updateProcessingId(String id, String processingId) async {
    try {
      final db = await dbHelper.database;
      await db.update(
        'business_cards',
        {
          'processing_id': processingId,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> deleteContact(String id) async {
    try {
      final db = await dbHelper.database;
      await db.delete('business_cards', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> cacheContacts(List<BusinessCardEntity> contacts) async {
    try {
      final db = await dbHelper.database;
      final now = DateTime.now().toIso8601String();

      final batch = db.batch();
      for (final contact in contacts) {
        batch.insert(
          'business_cards',
          _entityToRow(contact, now),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<PaginatedResult> getContactsPaginated(
    String userId, {
    required int offset,
    required int limit,
  }) async {
    try {
      final db = await dbHelper.database;
      final rows = await db.query(
        'business_cards',
        where: 'user_id = ? AND sync_status != ?',
        whereArgs: [userId, 'pending_delete'],
        orderBy: 'updated_at DESC',
        limit: limit,
        offset: offset,
      );
      final totalRows = await db.query(
        'business_cards',
        where: 'user_id = ? AND sync_status != ?',
        whereArgs: [userId, 'pending_delete'],
      );

      final items = rows.map(_rowToEntity).toList();
      final hasMore = (offset + limit) < totalRows.length;

      return PaginatedResult(items: items, hasMore: hasMore);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<BusinessCardEntity>> getPendingSync(String userId) async {
    try {
      final db = await dbHelper.database;
      final rows = await db.query(
        'business_cards',
        where: 'user_id = ? AND sync_status != ?',
        whereArgs: [userId, 'synced'],
      );
      return rows.map(_rowToEntity).toList();
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> updateSyncStatus(String id, SyncStatus status) async {
    try {
      final db = await dbHelper.database;
      await db.update(
        'business_cards',
        {
          'sync_status': status.value,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<BusinessCardEntity?> findByProcessingId(String processingId) async {
    try {
      final db = await dbHelper.database;
      final rows = await db.query(
        'business_cards',
        where: 'processing_id = ?',
        whereArgs: [processingId],
        limit: 1,
      );
      if (rows.isEmpty) return null;
      return _rowToEntity(rows.first);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  BusinessCardEntity _rowToEntity(Map<String, dynamic> row) {
    return BusinessCardEntity(
      id: row['id'] as String,
      userId: row['user_id'] as String?,
      fullName: row['full_name'] as String?,
      jobTitle: row['job_title'] as String?,
      company: row['company'] as String?,
      phone: row['phone'] as String?,
      email: row['email'] as String?,
      website: row['website'] as String?,
      linkedIn: row['linked_in'] as String?,
      facebook: row['facebook'] as String?,
      address: row['address'] as String?,
      notes: row['notes'] as String?,
      qrCodeContent: row['qr_code_content'] as String?,
      eventName: row['event_name'] as String?,
      location: row['location'] as String?,
      brief: row['brief'] as String?,
      keywords: row['keywords'] != null
          ? (jsonDecode(row['keywords'] as String) as List).cast<String>()
          : null,
      highlights: row['highlights'] != null
          ? (jsonDecode(row['highlights'] as String) as List).cast<String>()
          : null,
      images: row['images'] != null
          ? (jsonDecode(row['images'] as String) as List).cast<String>()
          : null,
      avatar: row['avatar_path'] as String?,
      createdAt: row['created_at'] != null
          ? DateTime.tryParse(row['created_at'] as String)
          : null,

      processingId: row['processing_id'] as String?,
      syncStatus: SyncStatus.fromValue(
        row['sync_status'] as String? ?? 'synced',
      ),
      uploadedAt: row['uploaded_at'] != null
          ? DateTime.tryParse(row['uploaded_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> _entityToRow(BusinessCardEntity e, String now) {
    return {
      'id': e.id,
      'user_id': e.userId,
      'full_name': e.fullName,
      'job_title': e.jobTitle,
      'company': e.company,
      'phone': e.phone,
      'email': e.email,
      'website': e.website,
      'linked_in': e.linkedIn,
      'facebook': e.facebook,
      'address': e.address,
      'notes': e.notes,
      'qr_code_content': e.qrCodeContent,
      'event_name': e.eventName,
      'location': e.location,
      'brief': e.brief,
      'keywords': e.keywords != null ? jsonEncode(e.keywords) : null,
      'highlights': e.highlights != null ? jsonEncode(e.highlights) : null,
      'images': e.images != null ? jsonEncode(e.images) : null,
      'avatar_path': e.avatar,
      'created_at': e.createdAt?.toIso8601String() ?? now,
      'updated_at': now,

      'processing_id': e.processingId,
      'sync_status': e.syncStatus.value,
      'uploaded_at': e.uploadedAt?.toIso8601String(),
    };
  }
}
