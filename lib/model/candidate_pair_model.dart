import 'dart:convert';

class CandidatePairModel {
  int? id;
  int presidentId;
  int vicePresidentId;
  int votes;
  CandidatePairModel({
    this.id,
    required this.presidentId,
    required this.vicePresidentId,
    this.votes = 0,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'presidentId': presidentId,
      'vicePresidentId': vicePresidentId,
      'votes': votes,
    };
  }

  factory CandidatePairModel.fromMap(Map<String, dynamic> map) {
    return CandidatePairModel(
      id: map['id'] != null ? map['id'] as int : null,
      presidentId: map['presidentId'] as int,
      vicePresidentId: map['vicePresidentId'] as int,
      votes: map['votes'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CandidatePairModel.fromJson(String source) =>
      CandidatePairModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
