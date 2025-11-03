import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CandidatePairModel {
  int? id;
  int presidentId;
  int vicePresidentId;
  String description;
  int votes;
  CandidatePairModel({
    this.id,
    required this.presidentId,
    required this.vicePresidentId,
    required this.description,
    this.votes = 0,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'presidentId': presidentId,
      'vicePresidentId': vicePresidentId,
      'description': description,
      'votes': votes,
    };
  }

  factory CandidatePairModel.fromMap(Map<String, dynamic> map) {
    return CandidatePairModel(
      id: map['id'] != null ? map['id'] as int : null,
      presidentId: map['presidentId'] as int,
      vicePresidentId: map['vicePresidentId'] as int,
      description: map['description'] as String,
      votes: map['votes'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CandidatePairModel.fromJson(String source) =>
      CandidatePairModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CandidatePairModel(id: $id, presidentId: $presidentId, vicePresidentId: $vicePresidentId, votes: $votes)';
  }
}
