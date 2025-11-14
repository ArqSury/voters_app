import 'dart:convert';

class VicePresidentModel {
  int? id;
  String name;
  String education;
  String? experience;
  String? achivement;
  String vision;
  String mission;
  String? imageUrl;
  VicePresidentModel({
    this.id,
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
      'name': name,
      'education': education,
      'experience': experience,
      'achivement': achivement,
      'vision': vision,
      'mission': mission,
      'imageUrl': imageUrl,
    };
  }

  factory VicePresidentModel.fromMap(Map<String, dynamic> map) {
    return VicePresidentModel(
      id: map['id'] != null ? map['id'] as int : null,
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

  factory VicePresidentModel.fromJson(String source) =>
      VicePresidentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VicePresidentModel(id: $id, name: $name, education: $education, mission: $mission, imageUrl: $imageUrl)';
  }
}
