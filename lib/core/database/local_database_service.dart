import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseService {
  static const String _databaseName = 'patient_favorites.db';
  static const int _databaseVersion = 1;

  Database? _database;

  // ✅ REMOVE STATIC - make it instance-based
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createTables,
    );
  }

  // ✅ REMOVE STATIC from this too
  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id TEXT PRIMARY KEY,
        patient_id TEXT NOT NULL,
        item_id TEXT NOT NULL,
        type TEXT NOT NULL,
        item_name TEXT NOT NULL,
        item_image TEXT,
        item_price REAL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_patient_id ON favorites(patient_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_item_type ON favorites(item_id, type)
    ''');
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}