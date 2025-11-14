import 'dart:convert';

class VoteModel {
  int? id;
  int citizenId;
  int candidatePairId;
  VoteModel({this.id, required this.citizenId, required this.candidatePairId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'citizenId': citizenId,
      'candidatePairId': candidatePairId,
    };
  }

  factory VoteModel.fromMap(Map<String, dynamic> map) {
    return VoteModel(
      id: map['id'] != null ? map['id'] as int : null,
      citizenId: map['citizenId'] as int,
      candidatePairId: map['candidatePairId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory VoteModel.fromJson(String source) =>
      VoteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VoteModel(id: $id, citizenId: $citizenId, candidatePairId: $candidatePairId)';
  }
}
