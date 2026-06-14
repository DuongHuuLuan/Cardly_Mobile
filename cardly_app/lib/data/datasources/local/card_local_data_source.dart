import 'dart:convert';

import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/data/datasources/local/database_helper.dart';
import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:cardly_app/domain/entities/scanned_document.dart';
import 'package:sqflite/sqflite.dart';

abstract class CardLocalDataSource {
  Future<List<ScannedDocument>> getScannedDocuments();
  Future<ScannedDocument> saveScannedDocument(ScannedDocument doc);
  Future<void> deleteScannedDocument(String id);
}

class CardLocalDataSourceImpl implements CardLocalDataSource {
  final DatabaseHelper dbHelper;

  CardLocalDataSourceImpl(this.dbHelper);

  @override
  Future<List<ScannedDocument>> getScannedDocuments() async {
    try {
      final db = await dbHelper.database;
      final rows = await db.rawQuery('''
        SELECT sd.*, bc.*
        FROM scanned_documents sd
        INNER JOIN business_cards bc ON bc.id = sd.card_id
        ORDER BY bc.created_at DESC
      ''');
      return rows.map(_rowToDocument).toList();
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<ScannedDocument> saveScannedDocument(ScannedDocument doc) async {
    try {
      final db = await dbHelper.database;
      final now = DateTime.now().toIso8601String();

      final card = (doc as BusinessCardDocument).card;
      final cardWithId = card.copyWith(
        id: card.id ?? doc.id,
        createdAt: card.createdAt ?? DateTime.now(),
      );
      final cardRow = {
        'id': cardWithId.id,
        'full_name': cardWithId.fullName,
        'job_title': cardWithId.jobTitle,
        'company': cardWithId.company,
        'phone': cardWithId.phone,
        'email': cardWithId.email,
        'website': cardWithId.website,
        'linked_in': cardWithId.linkedIn,
        'facebook': cardWithId.facebook,
        'address': cardWithId.address,
        'qr_code_content': cardWithId.qrCodeContent,
        'brief': cardWithId.brief,
        'keywords': cardWithId.keywords != null
            ? jsonEncode(cardWithId.keywords)
            : null,
        'highlights': cardWithId.highlights != null
            ? jsonEncode(cardWithId.highlights)
            : null,
        'images': cardWithId.images != null
            ? jsonEncode(cardWithId.images)
            : null,
        'created_at': cardWithId.createdAt?.toIso8601String(),
        'updated_at': now,
      };

      await db.transaction((txn) async {
        await txn.insert(
          'business_cards',
          cardRow,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        await txn.insert('scanned_documents', {
          'id': doc.id,
          'images': jsonEncode(doc.images),
          'card_id': cardWithId.id,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      });

      return doc;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> deleteScannedDocument(String id) async {
    try {
      final db = await dbHelper.database;
      await db.transaction((txn) async {
        final rows = await txn.query(
          'scanned_documents',
          columns: ['card_id'],
          where: 'id = ?',
          whereArgs: [id],
        );
        if (rows.isNotEmpty) {
          await txn.delete(
            'business_cards',
            where: 'id = ?',
            whereArgs: [rows.first['card_id']],
          );
        }
        await txn.delete('scanned_documents', where: 'id = ?', whereArgs: [id]);
      });
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  ScannedDocument _rowToDocument(Map<String, dynamic> row) {
    return BusinessCardDocument(
      id: row['id'] as String,
      images: row['images'] != null
          ? (jsonDecode(row['images'] as String) as List).cast<String>()
          : const [],
      card: BusinessCardEntity(
        id: row['card_id'] as String?,
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
      ),
    );
  }
}
