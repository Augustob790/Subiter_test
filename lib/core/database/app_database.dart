import 'package:sqflite/sqflite.dart';

class AppDatabase {
  Database? _database;

  Future<Database> get instance async => _database ??= await _open();

  Future<Database> _open() async {
    final String path = '${await getDatabasesPath()}/subiter.db';
    return openDatabase(
      path,
      version: 2,
      onCreate: (Database database, int version) async {
        await _createInspectionsTable(database);
        await _createActivitiesTable(database);
      },
      onUpgrade: (Database database, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await database.execute('DROP TABLE IF EXISTS cat_breeds');
          await _createInspectionsTable(database);
        }
      },
    );
  }

  Future<void> _createInspectionsTable(Database database) =>
      database.execute('''
        CREATE TABLE IF NOT EXISTS inspections(
          id TEXT PRIMARY KEY,
          payload TEXT NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');

  Future<void> _createActivitiesTable(Database database) => database.execute('''
        CREATE TABLE IF NOT EXISTS activities(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          company_name TEXT NOT NULL,
          location TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
}
