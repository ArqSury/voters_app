import 'dart:convert';

class PresidentModel {
  int? id;
  int? vicePresidentId;
  String name;
  String education;
  String? experience;
  String? achivement;
  String vision;
  String mission;
  String? imageUrl;
  PresidentModel({
    this.id,
    this.vicePresidentId,
    required this.name,
    required this.education,
    this.experience,
    this.achivement,
    required this.vision,
    required this.mission,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'vicePresidentId': vicePresidentId,
      'name': name,
      'education': education,
      'experience': experience,
      'achivement': achivement,
      'vision': vision,
      'mission': mission,
      'imageUrl': imageUrl,
    };
  }

  factory PresidentModel.fromMap(Map<String, dynamic> map) {
    return PresidentModel(
      id: map['id'] != null ? map['id'] as int : null,
      vicePresidentId: map['vicePresidentId'] != null
          ? map['vicePresidentId'] as int
          : null,
      name: (map['name'] ?? '') as String,
      education: (map['education'] ?? '') as String,
      experience: map['experience']?.toString(),
      achivement: map['achivement']?.toString(),
      vision: (map['vision'] ?? '') as String,
      mission: (map['mission'] ?? '') as String,
      imageUrl: map['imageUrl']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PresidentModel.fromJson(String source) =>
      PresidentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PresidentModel(id: $id, name: $name, education: $education, vision: $vision, imageUrl: $imageUrl)';
  }
}
