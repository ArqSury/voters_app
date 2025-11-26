import 'package:cloud_firestore/cloud_firestore.dart';

class PairsFirebase {
  final String id;
  final String presidentId;
  final String viceId;
  final int votes;
  final int number;
  final String? description;

  PairsFirebase({
    required this.id,
    required this.presidentId,
    required this.viceId,
    required this.votes,
    required this.number,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'presidentId': presidentId,
      'viceId': viceId,
      'votes': votes,
      'number': number,
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
      number: (data['number'] ?? 0) is int
          ? data['number']
          : int.tryParse(data['number'].toString()) ?? 0,
      description: data['description']?.toString(),
    );
  }
}
