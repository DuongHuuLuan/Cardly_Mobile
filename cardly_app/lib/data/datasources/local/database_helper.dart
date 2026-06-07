import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), "cardly.db");
    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE business_cards (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        full_name TEXT,
        job_title TEXT,
        company TEXT,
        phone TEXT,
        email TEXT,
        website TEXT,
        linked_in TEXT,
        facebook TEXT,
        address TEXT,
        notes TEXT,
        qr_code_content TEXT,
        event_name TEXT,
        location TEXT,
        brief TEXT,
        keywords TEXT,
        highlights TEXT,
        images TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE scanned_documents (
        id TEXT PRIMARY KEY,
        images TEXT NOT NULL DEFAULT '[]',
        card_id TEXT NOT NULL,
        FOREIGN KEY (card_id) REFERENCES business_cards(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE business_cards ADD COLUMN user_id TEXT DEFAULT ""',
      );
    }
  }
}
