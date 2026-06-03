import 'dart:convert';

import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/data/datasources/local/database_helper.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

abstract class ContactLocalDataSource {
  Future<List<BusinessCardEntity>> getContacts();
  Future<BusinessCardEntity> saveContact(BusinessCardEntity contact);
  Future<void> deleteContact(String id);
  Future<void> cacheContacts(List<BusinessCardEntity> contacts);
}

class ContactLocalDataSourceImpl implements ContactLocalDataSource {
  final DatabaseHelper dbHelper;

  ContactLocalDataSourceImpl(this.dbHelper);

  @override
  Future<List<BusinessCardEntity>> getContacts() async {
    try {
      final db = await dbHelper.database;
      final rows = await db.query('business_cards', orderBy: 'created_at DESC');
      return rows.map(_rowToEntity).toList();
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<BusinessCardEntity> saveContact(BusinessCardEntity contact) async {
    try {
      final db = await dbHelper.database;
      final id = contact.id ?? const Uuid().v4();
      final now = DateTime.now().toIso8601String();

      final entity = contact.copyWith(id: id);
      final row = _entityToRow(entity, now);

      await db.insert(
        'business_cards',
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return entity;
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

  BusinessCardEntity _rowToEntity(Map<String, dynamic> row) {
    return BusinessCardEntity(
      id: row['id'] as String,
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
      createdAt: row['created_at'] != null
          ? DateTime.tryParse(row['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> _entityToRow(BusinessCardEntity e, String now) {
    return {
      'id': e.id,
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
      'created_at': e.createdAt?.toIso8601String() ?? now,
      'updated_at': now,
    };
  }
}
