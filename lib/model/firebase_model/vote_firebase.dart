import 'package:cloud_firestore/cloud_firestore.dart';

class VoteFirebase {
  final String id;
  final String citizenId;
  final String pairId;
  final DateTime createdAt;

  VoteFirebase({
    required this.id,
    required this.citizenId,
    required this.pairId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'citizenId': citizenId,
      'pairId': pairId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory VoteFirebase.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return VoteFirebase(
      id: doc.id,
      citizenId: data['citizenId'] ?? '',
      pairId: data['pairId'] ?? '',
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
