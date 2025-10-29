import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:voters_app/model/citizen_model.dart';

class DbHelper {
  static const tableCitizen = 'citizen';
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'citizen.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $tableCitizen(id INTEGER PRIMARY KEY AUTOINCREMENT, name Text, province TEXT, password TEXT, nik int, noHp int)',
        );
      },

      version: 1,
    );
  }

  static Future<void> registerCitizen(CitizenModel citizen) async {
    final dbs = await db();
    await dbs.insert(
      tableCitizen,
      citizen.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<CitizenModel?> loginCitizen({
    required String name,
    required String password,
  }) async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(
      tableCitizen,
      where: 'name = ? AND password = ?',
      whereArgs: [name, password],
    );
    if (results.isNotEmpty) {
      return CitizenModel.fromMap(results.first);
    }
    return null;
  }

  static Future<List<CitizenModel>> getAllCitizen() async {
    final db = await DbHelper.db();
    final List<Map<String, dynamic>> results = await db.query(tableCitizen);
    return results.map((e) => CitizenModel.fromMap(e)).toList();
  }

  static Future<void> updateCitizen(CitizenModel citizen) async {
    final dbs = await db();
    await dbs.update(
      tableCitizen,
      citizen.toMap(),
      where: 'id = ?',
      whereArgs: [citizen.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
