import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../app_models/blood_pressure_record.dart';
import '../app_models/blood_sugar_record.dart';
import '../app_models/heart_rate_record.dart';
import '../app_models/weight_bmi_record.dart';
import '../app_models/alarm_record.dart';

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
      version: 5,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
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

    await _createAlarmsTable(db);
    await _createSugarTable(db);
    await _createHeartRateTable(db);
    await _createWeightBmiTable(db);
  }

  Future _createAlarmsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS vitals_alarms (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        type TEXT NOT NULL,
        frequency TEXT NOT NULL,
        nextExecution TEXT NOT NULL,
        hour INTEGER NOT NULL,
        minute INTEGER NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        neverEnd INTEGER NOT NULL,
        isEnabled INTEGER NOT NULL
      )
    ''');
  }

  Future _createSugarTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS blood_sugar_records (
        id TEXT PRIMARY KEY,
        value REAL NOT NULL,
        unit TEXT NOT NULL,
        date TEXT NOT NULL,
        state TEXT NOT NULL,
        note TEXT NOT NULL
      )
    ''');
  }

  Future _createHeartRateTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS heart_rate_records (
        id TEXT PRIMARY KEY,
        bpm INTEGER NOT NULL,
        date TEXT NOT NULL,
        status TEXT NOT NULL,
        gender TEXT NOT NULL,
        age INTEGER NOT NULL,
        note TEXT NOT NULL
      )
    ''');
  }

  Future _createWeightBmiTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS weight_bmi_records (
        id TEXT PRIMARY KEY,
        weightKg REAL NOT NULL,
        heightCm REAL NOT NULL,
        bmi REAL NOT NULL,
        date TEXT NOT NULL,
        gender TEXT NOT NULL,
        age INTEGER NOT NULL,
        note TEXT NOT NULL
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createAlarmsTable(db);
    }
    if (oldVersion < 3) {
      await _createSugarTable(db);
    }
    if (oldVersion < 4) {
      await _createHeartRateTable(db);
    }
    if (oldVersion < 5) {
      await _createWeightBmiTable(db);
    }
  }

  // --- Blood Pressure Records ---
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

  // --- Blood Sugar Records ---
  Future<int> insertSugarRecord(BloodSugarRecord record) async {
    final db = await instance.database;
    return await db.insert(
      'blood_sugar_records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BloodSugarRecord>> getAllSugarRecords() async {
    final db = await instance.database;
    final result = await db.query(
      'blood_sugar_records',
      orderBy: 'date DESC',
    );

    return result.map((json) => BloodSugarRecord.fromMap(json)).toList();
  }

  Future<BloodSugarRecord?> getSugarRecordById(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'blood_sugar_records',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return BloodSugarRecord.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateSugarRecord(BloodSugarRecord record) async {
    final db = await instance.database;
    return await db.update(
      'blood_sugar_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteSugarRecord(String id) async {
    final db = await instance.database;
    return await db.delete(
      'blood_sugar_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- Heart Rate Records ---
  Future<int> insertHeartRateRecord(HeartRateRecord record) async {
    final db = await instance.database;
    return await db.insert(
      'heart_rate_records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<HeartRateRecord>> getAllHeartRateRecords() async {
    final db = await instance.database;
    final result = await db.query(
      'heart_rate_records',
      orderBy: 'date DESC',
    );

    return result.map((json) => HeartRateRecord.fromMap(json)).toList();
  }

  Future<HeartRateRecord?> getHeartRateRecordById(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'heart_rate_records',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return HeartRateRecord.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateHeartRateRecord(HeartRateRecord record) async {
    final db = await instance.database;
    return await db.update(
      'heart_rate_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteHeartRateRecord(String id) async {
    final db = await instance.database;
    return await db.delete(
      'heart_rate_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- Weight & BMI Records ---
  Future<int> insertWeightBmiRecord(WeightBmiRecord record) async {
    final db = await instance.database;
    return await db.insert(
      'weight_bmi_records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<WeightBmiRecord>> getAllWeightBmiRecords() async {
    final db = await instance.database;
    final result = await db.query(
      'weight_bmi_records',
      orderBy: 'date DESC',
    );

    return result.map((json) => WeightBmiRecord.fromMap(json)).toList();
  }

  Future<WeightBmiRecord?> getWeightBmiRecordById(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'weight_bmi_records',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return WeightBmiRecord.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateWeightBmiRecord(WeightBmiRecord record) async {
    final db = await instance.database;
    return await db.update(
      'weight_bmi_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteWeightBmiRecord(String id) async {
    final db = await instance.database;
    return await db.delete(
      'weight_bmi_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- Vitals Alarms CRUD ---
  Future<int> insertAlarm(AlarmRecord alarm) async {
    final db = await instance.database;
    return await db.insert(
      'vitals_alarms',
      alarm.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AlarmRecord>> getAllAlarms() async {
    final db = await instance.database;
    final result = await db.query(
      'vitals_alarms',
      orderBy: 'hour ASC, minute ASC',
    );

    return result.map((json) => AlarmRecord.fromMap(json)).toList();
  }

  Future<int> updateAlarm(AlarmRecord alarm) async {
    final db = await instance.database;
    return await db.update(
      'vitals_alarms',
      alarm.toMap(),
      where: 'id = ?',
      whereArgs: [alarm.id],
    );
  }

  Future<int> deleteAlarm(String id) async {
    final db = await instance.database;
    return await db.delete(
      'vitals_alarms',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
