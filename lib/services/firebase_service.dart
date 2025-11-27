import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voters_app/model/firebase_model/admin_firebase.dart';
import 'package:voters_app/model/firebase_model/citizen_firebase.dart';
import 'package:voters_app/model/firebase_model/pair_with_names.dart';
import 'package:voters_app/model/firebase_model/pairs_firebase.dart';
import 'package:voters_app/model/firebase_model/president_firebase.dart';
import 'package:voters_app/model/firebase_model/vice_firebase.dart';
import 'package:voters_app/model/firebase_model/vote_firebase.dart';

class FirebaseService {
  FirebaseService._internal(this._auth, this._db);
  FirebaseFirestore get firestore => _db;
  static final FirebaseService instance = FirebaseService._internal(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  static const String _citizensCol = 'citizens';
  static const String _adminsCol = 'admins';
  static const String _presidentsCol = 'presidents';
  static const String _vicePresidentsCol = 'vice_presidents';
  static const String _pairsCol = 'pairs';
  static const String _votesCol = 'votes';

  Future<CitizenFirebase> registerCitizen({
    required String email,
    required String password,
    required String name,
    required String province,
    required String city,
    required int nik,
    required String phone,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;
    final citizen = CitizenFirebase(
      id: uid,
      email: email,
      name: name,
      province: province,
      city: city,
      nik: nik,
      phone: phone,
      imageBase64: null,
      createdAt: DateTime.now(),
    );
    await _db.collection(_citizensCol).doc(uid).set(citizen.toMap());
    return citizen;
  }

  Future<UserCredential> loginCitizen({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final doc = await _db.collection(_citizensCol).doc(cred.user!.uid).get();
    if (!doc.exists) {
      await _auth.signOut();
      throw Exception('Akun ini bukan warga.');
    }
    return cred;
  }

  Future<CitizenFirebase?> getCurrentCitizen() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _db.collection(_citizensCol).doc(user.uid).get();
    return CitizenFirebase.fromDoc(doc);
  }

  Future<void> updateCitizenProfile(CitizenFirebase citizen) async {
    await _db.collection(_citizensCol).doc(citizen.id).update(citizen.toMap());
  }

  Future<void> updateCitizenPhoto(String base64) async {
    final uid = _auth.currentUser!.uid;
    await _db.collection(_citizensCol).doc(uid).update({'imageBase64': base64});
  }

  Future<void> resetCitizenPasswordWithVerification({
    required String email,
    required int nik,
    required String phone,
  }) async {
    final query = await _db
        .collection(_citizensCol)
        .where('email', isEqualTo: email)
        .where('nik', isEqualTo: nik)
        .where('phone', isEqualTo: phone)
        .limit(1)
        .get();
    if (query.docs.isEmpty) {
      throw Exception('Data identitas tidak cocok.');
    }
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<AdminFirebase> registerAdmin({
    required String email,
    required String password,
    required String name,
    bool isSuperAdmin = false,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await cred.user!.sendEmailVerification();
    final uid = cred.user!.uid;
    final admin = AdminFirebase(
      id: uid,
      email: email,
      name: name,
      isSuperAdmin: isSuperAdmin,
      createdAt: DateTime.now(),
    );
    await _db.collection(_adminsCol).doc(uid).set(admin.toMap());
    return admin;
  }

  Future<UserCredential> loginAdmin({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final doc = await _db.collection(_adminsCol).doc(cred.user!.uid).get();
    if (!doc.exists) {
      await _auth.signOut();
      throw Exception('Akun ini bukan admin.');
    }
    final admin = AdminFirebase.fromDoc(doc);
    if (!admin.isSuperAdmin && !(cred.user!.emailVerified)) {
      await _auth.signOut();
      throw Exception('Email admin belum diverifikasi (OTP).');
    }
    return cred;
  }

  Future<AdminFirebase?> getCurrentAdmin() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _db.collection(_adminsCol).doc(user.uid).get();
    if (!doc.exists) return null;
    return AdminFirebase.fromDoc(doc);
  }

  Future<PresidenFirebase> addPresident({
    required String name,
    required int age,
    required String gender,
    required String education,
    String? experience,
    String? achivement,
    required String vision,
    required String mission,
    String? imageBase64,
  }) async {
    final ref = _db.collection(_presidentsCol).doc();
    final pres = PresidenFirebase(
      id: ref.id,
      name: name,
      age: age,
      gender: gender,
      education: education,
      experience: experience,
      achivement: achivement,
      vision: vision,
      mission: mission,
      imageBase64: imageBase64,
    );
    await ref.set(pres.toMap());
    return pres;
  }

  Future<ViceFirebase> addVice({
    required String name,
    required int age,
    required String gender,
    required String education,
    String? experience,
    String? achivement,
    required String vision,
    required String mission,
    String? imageBase64,
  }) async {
    final ref = _db.collection(_vicePresidentsCol).doc();
    final vice = ViceFirebase(
      id: ref.id,
      name: name,
      age: age,
      gender: gender,
      education: education,
      experience: experience,
      achivement: achivement,
      vision: vision,
      mission: mission,
      imageBase64: imageBase64,
    );
    await ref.set(vice.toMap());
    return vice;
  }

  Future<PairsFirebase> addCandidatePair({
    required PresidenFirebase president,
    required ViceFirebase vice,
    String? description,
  }) async {
    final snap = await _db.collection(_pairsCol).get();
    final nextNumber = snap.docs.length + 1;
    final ref = _db.collection(_pairsCol).doc();
    final pair = PairsFirebase(
      id: ref.id,
      presidentId: president.id,
      viceId: vice.id,
      votes: 0,
      number: nextNumber,
      description: description,
    );
    await ref.set(pair.toMap());
    return pair;
  }

  Future<void> editCandidatePair({
    required PairsFirebase pair,
    required PresidenFirebase president,
    required ViceFirebase vice,
  }) async {
    final batch = _db.batch();
    final presRef = _db.collection(_presidentsCol).doc(president.id);
    batch.update(presRef, president.toMap());
    final viceRef = _db.collection(_vicePresidentsCol).doc(vice.id);
    batch.update(viceRef, vice.toMap());
    final pairRef = _db.collection(_pairsCol).doc(pair.id);
    batch.update(pairRef, {'description': pair.description});
    await batch.commit();
  }

  Future<void> deleteCandidatePair(String pairId) async {
    final pairRef = _db.collection(_pairsCol).doc(pairId);
    final pairSnap = await pairRef.get();
    if (!pairSnap.exists) return;
    final pair = PairsFirebase.fromDoc(pairSnap);
    final batch = _db.batch();
    final votesSnap = await _db
        .collection(_votesCol)
        .where('pairId', isEqualTo: pairId)
        .get();
    for (final doc in votesSnap.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(pairRef);
    final presRef = _db.collection(_presidentsCol).doc(pair.presidentId);
    final viceRef = _db.collection(_vicePresidentsCol).doc(pair.viceId);
    batch.delete(presRef);
    batch.delete(viceRef);
    await batch.commit();
  }

  Future<List<PairsFirebase>> getAllPairs() async {
    final snap = await _db.collection(_pairsCol).get();
    return snap.docs.map((d) => PairsFirebase.fromDoc(d)).toList();
  }

  Stream<List<PairsFirebase>> watchAllPairs() {
    return _db
        .collection(_pairsCol)
        .snapshots()
        .map((snap) => snap.docs.map((d) => PairsFirebase.fromDoc(d)).toList());
  }

  Future<bool> hasCitizenVoted(String citizenId) async {
    final snap = await _db
        .collection(_votesCol)
        .where('citizenId', isEqualTo: citizenId)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }

  Future<bool> castVote({
    required String citizenId,
    required String pairId,
  }) async {
    final existing = await _db
        .collection(_votesCol)
        .where('citizenId', isEqualTo: citizenId)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) return false;
    return _db.runTransaction<bool>((txn) async {
      final voteRef = _db.collection(_votesCol).doc();
      final vote = VoteFirebase(
        id: voteRef.id,
        citizenId: citizenId,
        pairId: pairId,
        createdAt: DateTime.now(),
      );
      txn.set(voteRef, vote.toMap());
      final pairRef = _db.collection(_pairsCol).doc(pairId);
      txn.update(pairRef, {'votes': FieldValue.increment(1)});
      return true;
    });
  }

  Future<void> resetAllVotes() async {
    final batch = _db.batch();
    final pairsSnap = await _db.collection(_pairsCol).get();
    for (final doc in pairsSnap.docs) {
      batch.update(doc.reference, {'votes': 0});
    }
    final votesSnap = await _db.collection(_votesCol).get();
    for (final doc in votesSnap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Stream<List<PairsFirebase>> watchVotingResults() {
    return _db
        .collection(_pairsCol)
        .orderBy('votes', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => PairsFirebase.fromDoc(d)).toList());
  }

  Stream<List<PairWithNames>> watchVotingResultsWithNames() async* {
    await for (final pairs in watchVotingResults()) {
      final List<PairWithNames> result = [];
      for (final pair in pairs) {
        final presDoc = await _db
            .collection(_presidentsCol)
            .doc(pair.presidentId)
            .get();
        final pres = presDoc.exists ? PresidenFirebase.fromDoc(presDoc) : null;
        final viceDoc = await _db
            .collection(_vicePresidentsCol)
            .doc(pair.viceId)
            .get();
        final vice = viceDoc.exists ? ViceFirebase.fromDoc(viceDoc) : null;
        result.add(
          PairWithNames(
            pair: pair,
            presidentName: pres?.name ?? "Presiden",
            viceName: vice?.name ?? "Wakil Presiden",
            presidentImagePath: pres?.imageBase64,
            viceImagePath: vice?.imageBase64,
            number: pair.number,
          ),
        );
      }
      yield result;
    }
  }
}
