import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:voters_app/model/citizen_model.dart';
import 'package:voters_app/share_preference/preference_handler.dart';

class DbHelper {
  static const tableCitizen = 'citizen';
  static const tableAdmin = 'admin';
  static const tablePresident = 'president';
  static const tableVicePresident = 'vice_president';
  static const tableCandidatePair = 'candidate_pair';
  static const tableVote = 'vote';

  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'voting.db'),
      onCreate: (db, version) async {
        //Citizen Table
        await db.execute(
          'CREATE TABLE $tableCitizen(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, province TEXT, password TEXT, nik int, phone int)',
        );
        //Admin Table
        await db.execute(
          'CREATE TABLE $tableAdmin (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE, password TEXT)',
        );
        //President Table
        await db.execute(
          'CREATE TABLE $tablePresident (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, education TEXT, experience TEXT, achivement TEXT, vision TEXT, imageUrl)',
        );
        //Vice President Table
        await db.execute(
          'CREATE TABLE $tableVicePresident (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, education TEXT, experience TEXT, achivement TEXT, vision TEXT, imageUrl)',
        );
        //Candidate Pair Table
        await db.execute(
          'CREATE TABLE $tableCandidatePair (id INTEGER PRIMARY KEY AUTOINCREMENT, presidentId int, vicePresidentId int, description TEXT, votes INTEGER DEFAULT 0, FOREIGN KEY (presidentId) REFERENCES $tablePresident (id), FOREIGN KEY (vicePresidentId) REFERENCES $tableVicePresident (id))',
        );
        //Vote Table
        await db.execute(
          'CREATE TABLE $tableVote (id INTEGER PRIMARY KEY AUTOINCREMENT, citizenId int, pairId int, FOREIGN KEY (pairId) REFERENCES $tableCandidatePair (id), FOREIGN KEY (citizenId) REFERENCES $tableCitizen (id))',
        );
      },

      version: 1,
    );
  }

  //Citizen
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
      PreferenceHandler.saveId(results.first['id']);
      return CitizenModel.fromMap(results.first);
    }
    return null;
  }

  static Future<List<CitizenModel>> getAllCitizen() async {
    final db = await DbHelper.db();
    final List<Map<String, dynamic>> results = await db.query(tableCitizen);
    return results.map((e) => CitizenModel.fromMap(e)).toList();
  }

  static Future<CitizenModel?> getCitizenById(int id) async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(
      tableCitizen,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return CitizenModel.fromMap(results.first);
    }
    return null;
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

  static Future<void> deleteCitizen(int id) async {
    final dbs = await db();
    await dbs.delete(tableCitizen, where: 'id = ?', whereArgs: [id]);
  }

  //ADMIN
  static Future<void> registerAdmin(String username, String password) async {
    final dbs = await db();
    await dbs.insert(tableAdmin, {
      'username': username,
      'password': password,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<bool> loginAdmin(String username, String password) async {
    final dbs = await db();
    final res = await dbs.query(
      tableAdmin,
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return res.isNotEmpty;
  }

  // CANDIDATES
  static Future<int> addPresident({
    required String name,
    required String education,
    required String experience,
    required String achivement,
    required String vision,
    required String imageUrl,
  }) async {
    final dbs = await db();
    return await dbs.insert(tablePresident, {
      'name': name,
      'education': education,
      'experience': experience,
      'achivement': achivement,
      'vision': vision,
      'imageUrl': imageUrl,
    });
  }

  static Future<int> addVicePresident({
    required String name,
    required String education,
    required String experience,
    required String achivement,
    required String vision,
    required String imageUrl,
  }) async {
    final dbs = await db();
    return await dbs.insert(tableVicePresident, {
      'name': name,
      'education': education,
      'experience': experience,
      'achivement': achivement,
      'vision': vision,
      'imageUrl': imageUrl,
    });
  }

  static Future<void> linkCandidatePair({
    required int presidentId,
    required int vicePresidentId,
    required String description,
  }) async {
    final dbs = await db();
    await dbs.insert(tableCandidatePair, {
      'presidentId': presidentId,
      'vicePresidentId': vicePresidentId,
      'description': description,
      'votes': 0,
    });
  }

  static Future<List<Map<String, dynamic>>> getAllCandidatePairs() async {
    final dbs = await db();
    return await dbs.rawQuery(
      'SELECT cp.id AS pairId, p.name AS presidentName, p.vision AS presidentVision, v.name AS viceName, v.vision AS viceVision, cp.votes AS votes, cp.description AS description, FROM $tableCandidatePair cp JOIN $tablePresident p ON cp.presidentId = p.id JOIN $tableVicePresident v ON cp.vicePresidentId = v.id',
    );
  }

  // VOTING
  static Future<bool> hasCitizenVoted(int citizenId) async {
    final dbs = await db();
    final res = await dbs.query(
      tableVote,
      where: 'citizenId = ?',
      whereArgs: [citizenId],
    );
    return res.isNotEmpty;
  }

  static Future<void> castVote(int citizenId, int pairId) async {
    final dbs = await db();
    final alreadyVoted = await hasCitizenVoted(citizenId);
    if (!alreadyVoted) {
      await dbs.insert(tableVote, {'citizenId': citizenId, 'pairId': pairId});
      await dbs.rawUpdate(
        'UPDATE $tableCandidatePair SET votes = votes + 1 WHERE id = ?',
        [pairId],
      );
    }
  }

  static Future<List<Map<String, dynamic>>> getVotingResults() async {
    final dbs = await db();
    return await dbs.rawQuery(
      'SELECT cp.id AS pairId, p.name AS presidentName, v.name AS viceName, cp.votes AS votes, FROM $tableCandidatePair cp JOIN $tablePresident p ON cp.presidentId = p.Id JOIN $tableVicePresident v ON cp.vicePresidentId = v.Id ORDER BY cp.votes DESC',
    );
  }
}
