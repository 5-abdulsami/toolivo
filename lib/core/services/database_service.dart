import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';

class DatabaseService extends GetxService {
  static Database? _database;

  Future<DatabaseService> init() async {
    await _initDatabase();
    return this;
  }

  Database get database {
    if (_database != null) return _database!;
    throw Exception('Database not initialized');
  }

  Future<void> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'toolivo.db');

    _database = await openDatabase(path, version: 1, onCreate: _createTables);
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        customer_id TEXT,
        property_address TEXT,
        start_date TEXT,
        status TEXT NOT NULL,
        work_verified INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE materials (
        id TEXT PRIMARY KEY,
        task_id TEXT NOT NULL,
        type TEXT NOT NULL,
        description TEXT NOT NULL,
        quantity REAL NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (task_id) REFERENCES tasks (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE customers (
        id TEXT PRIMARY KEY,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE properties (
        id TEXT PRIMARY KEY,
        customer_id TEXT NOT NULL,
        address TEXT NOT NULL,
        renter TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES customers (id)
      )
    ''');
  }
}
