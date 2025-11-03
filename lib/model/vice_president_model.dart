import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class VicePresidentModel {
  int? id;
  String name;
  String education;
  String experience;
  String achivement;
  String vision;
  String imageUrl;
  VicePresidentModel({
    this.id,
    required this.name,
    required this.education,
    required this.experience,
    required this.achivement,
    required this.vision,
    required this.imageUrl,
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

  factory VicePresidentModel.fromMap(Map<String, dynamic> map) {
    return VicePresidentModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      education: map['education'] as String,
      experience: map['experience'] as String,
      achivement: map['achivement'] as String,
      vision: map['vision'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory VicePresidentModel.fromJson(String source) =>
      VicePresidentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VicePresidentModel(id: $id, name: $name, education: $education, vision: $vision, imageUrl: $imageUrl)';
  }
}
