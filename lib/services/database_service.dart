import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import '../models/sensor_data.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'plant_monitoring.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sensor_readings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        plant1_moisture INTEGER NOT NULL,
        plant1_light INTEGER NOT NULL,
        plant1_rain BOOLEAN NOT NULL,
        plant1_pump BOOLEAN NOT NULL,
        plant2_moisture INTEGER NOT NULL,
        plant2_light INTEGER NOT NULL,
        plant2_rain BOOLEAN NOT NULL,
        plant2_pump BOOLEAN NOT NULL,
        temperature REAL NOT NULL,
        humidity REAL NOT NULL,
        gas INTEGER NOT NULL,
        water_tank BOOLEAN NOT NULL
      )
    ''');
  }

  Future<void> saveSensorData(SensorData data) async {
    final db = await database;
    final now = DateTime.now();
    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    await db.insert('sensor_readings', {
      'timestamp': timestamp,
      'plant1_moisture': data.plant1.moisture,
      'plant1_light': data.plant1.light,
      'plant1_rain': data.plant1.rain ? 1 : 0,
      'plant1_pump': data.plant1.pump ? 1 : 0,
      'plant2_moisture': data.plant2.moisture,
      'plant2_light': data.plant2.light,
      'plant2_rain': data.plant2.rain ? 1 : 0,
      'plant2_pump': data.plant2.pump ? 1 : 0,
      'temperature': data.environment.temperature,
      'humidity': data.environment.humidity,
      'gas': data.environment.gas,
      'water_tank': data.environment.waterTank ? 1 : 0,
    });
  }

  Future<List<Map<String, dynamic>>> getSensorHistory() async {
    final db = await database;
    return await db.query('sensor_readings', orderBy: 'timestamp DESC');
  }
} 