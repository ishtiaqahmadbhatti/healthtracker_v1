import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../app_models/blood_pressure_record.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('healthtracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE blood_pressure_records (
        id TEXT PRIMARY KEY,
        sys INTEGER NOT NULL,
        dia INTEGER NOT NULL,
        pul INTEGER NOT NULL,
        date TEXT NOT NULL,
        body_position TEXT NOT NULL,
        measured_arm TEXT NOT NULL,
        tag TEXT NOT NULL,
        note TEXT NOT NULL
      )
    ''');
  }

  Future<BloodPressureRecord?> getRecordById(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'blood_pressure_records',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return BloodPressureRecord.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertRecord(BloodPressureRecord record) async {
    final db = await instance.database;
    return await db.insert(
      'blood_pressure_records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BloodPressureRecord>> getAllRecords() async {
    final db = await instance.database;
    final result = await db.query(
      'blood_pressure_records',
      orderBy: 'date DESC',
    );

    return result.map((json) => BloodPressureRecord.fromMap(json)).toList();
  }

  Future<int> deleteRecord(String id) async {
    final db = await instance.database;
    return await db.delete(
      'blood_pressure_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateRecord(BloodPressureRecord record) async {
    final db = await instance.database;
    return await db.update(
      'blood_pressure_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
