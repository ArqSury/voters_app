import 'package:cloud_firestore/cloud_firestore.dart';

class PairsFirebase {
  final String id;
  final String presidentId;
  final String viceId;
  final int votes;
  final String? description;

  PairsFirebase({
    required this.id,
    required this.presidentId,
    required this.viceId,
    required this.votes,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'presidentId': presidentId,
      'viceId': viceId,
      'votes': votes,
      'description': description,
    };
  }

  factory PairsFirebase.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return PairsFirebase(
      id: doc.id,
      presidentId: data['presidentId'] ?? '',
      viceId: data['viceId'] ?? '',
      votes: (data['votes'] ?? 0) is int
          ? data['votes'] as int
          : int.tryParse(data['votes'].toString()) ?? 0,
      description: data['description']?.toString(),
    );
  }
}
