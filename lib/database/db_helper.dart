import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:voters_app/model/admin_model.dart';
import 'package:voters_app/model/citizen_model.dart';
import 'package:voters_app/model/president_model.dart';
import 'package:voters_app/model/vice_president_model.dart';
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
          'CREATE TABLE $tablePresident (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, education TEXT, experience TEXT, achivement TEXT, vision TEXT, mission TEXT, imageUrl TEXT, vicePresidentId int)',
        );
        //Vice President Table
        await db.execute(
          'CREATE TABLE $tableVicePresident (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, education TEXT, experience TEXT, achivement TEXT, vision TEXT, mission TEXT, imageUrl TEXT)',
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
  static Future<void> registerAdmin(AdminModel admin) async {
    final dbs = await db();
    await dbs.insert(
      tableAdmin,
      admin.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<AdminModel?> loginAdmin({
    required String username,
    required String password,
  }) async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(
      tableAdmin,
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (results.isNotEmpty) {
      return AdminModel.fromMap(results.first);
    }
    return null;
  }

  // CANDIDATES

  static Future<void> registerPresident(PresidentModel president) async {
    final dbs = await db();
    await dbs.insert(
      tablePresident,
      president.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<PresidentModel>> getAllPresidents() async {
    final dbs = await db();
    final List<Map<String, dynamic>> result = await dbs.query(tablePresident);
    return result.map((e) => PresidentModel.fromMap(e)).toList();
  }

  static Future<void> deletePresident(int id) async {
    final dbs = await db();
    await dbs.delete(tablePresident, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> registerVicePresident(VicePresidentModel vice) async {
    final dbs = await db();
    await dbs.insert(
      tableVicePresident,
      vice.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<VicePresidentModel>> getAllVicePresidents() async {
    final dbs = await db();
    final List<Map<String, dynamic>> result = await dbs.query(
      tableVicePresident,
    );
    return result.map((e) => VicePresidentModel.fromMap(e)).toList();
  }

  static Future<void> deleteVicePresident(int id) async {
    final dbs = await db();
    await dbs.delete(tableVicePresident, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> addCandidatePair({
    required PresidentModel president,
    required VicePresidentModel vicePresident,
  }) async {
    final dbs = await db();
    final vpId = await dbs.insert(tableVicePresident, vicePresident.toMap());
    final presId = await dbs.insert(tablePresident, president.toMap());
    await dbs.insert(tableCandidatePair, {
      'presidentId': presId,
      'vicePresidentId': vpId,
    });
  }

  static Future<List<Map<String, dynamic>>> getAllPairs() async {
    final dbs = await db();
    final result = await dbs.rawQuery('''
    SELECT 
      p.id AS presidentId,
      p.name AS presidentName,
      p.education AS pEducation,
      p.experience AS pExperience,
      p.achivement AS pAchivement,
      p.vision AS pVision,
      p.imageUrl AS pImage,
      v.id AS vicePresidentId,
      v.name AS vicePresidentName,
      v.education AS vEducation,
      v.experience AS vExperience,
      v.achivement AS vAchivement,
      v.mission AS vMission,
      v.imageUrl AS vImage
    FROM $tableCandidatePair cp
    INNER JOIN $tablePresident p ON cp.presidentId = p.id
    INNER JOIN $tableVicePresident v ON cp.vicePresidentId = v.id
  ''');
    return result;
  }

  static Future<void> deleteCandidatePair(int pairId) async {
    final dbs = await db();

    // Get the linked president and vice president IDs first
    final List<Map<String, dynamic>> pair = await dbs.query(
      tableCandidatePair,
      where: 'id = ?',
      whereArgs: [pairId],
    );

    if (pair.isNotEmpty) {
      final presId = pair.first['presidentId'];
      final viceId = pair.first['vicePresidentId'];

      // Delete the pair link
      await dbs.delete(
        tableCandidatePair,
        where: 'id = ?',
        whereArgs: [pairId],
      );

      // Delete linked president and vice president
      await dbs.delete(tablePresident, where: 'id = ?', whereArgs: [presId]);

      await dbs.delete(
        tableVicePresident,
        where: 'id = ?',
        whereArgs: [viceId],
      );
    }
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
