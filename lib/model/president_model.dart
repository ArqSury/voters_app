import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PresidentModel {
  int? id;
  String name;
  String education;
  String? experience;
  String? achivement;
  String vision;
  String? imageUrl;
  PresidentModel({
    this.id,
    required this.name,
    required this.education,
    this.experience,
    this.achivement,
    required this.vision,
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
      'imageUrl': imageUrl,
    };
  }

  factory PresidentModel.fromMap(Map<String, dynamic> map) {
    return PresidentModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      education: map['education'] as String,
      experience: map['experience'] != null
          ? map['experience'] as String
          : null,
      achivement: map['achivement'] != null
          ? map['achivement'] as String
          : null,
      vision: map['vision'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
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
