import 'package:kins_v002/constant/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserSqfliteDatabase {
  UserSqfliteDatabase._();

  static UserSqfliteDatabase db = UserSqfliteDatabase._();
  Database? _database;

  deleteMyDatabase() async {
    String path = join(await getDatabasesPath(), 'User_sql_lite_data.db');
    deleteDatabase(path);
  }

  Future<Database> get database async {
    if (_database == null) {
      return await _initDB();
    } else {
      return _database!;
    }
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'User_sql_lite_data.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
      CREATE TABLE $tableUsers (
      $fieldId TEXT PRIMARY KEY,
      $fieldToken TEXT,
      $fieldName TEXT,
      $fieldEmail TEXT,
      $fieldPhone TEXT,
      $fieldGender TEXT,
      $fieldProfile TEXT,
      $fieldSpouse TEXT,
      $fieldDad TEXT,
      $fieldMom TEXT,
      $fieldLink TEXT
      )
      ''');
      },
    );
  }
}
