import 'package:cloud_firestore/cloud_firestore.dart';

class ViceFirebase {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String education;
  final String? experience;
  final String? achivement;
  final String vision;
  final String mission;
  final String? imagePath;

  ViceFirebase({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.education,
    this.experience,
    this.achivement,
    required this.vision,
    required this.mission,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'education': education,
      'experience': experience,
      'achivement': achivement,
      'vision': vision,
      'mission': mission,
      'imagePath': imagePath,
    };
  }

  factory ViceFirebase.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ViceFirebase(
      id: doc.id,
      name: data['name'] ?? '',
      age: (data['age'] ?? 0) is int
          ? data['age'] as int
          : int.tryParse(data['age'].toString()) ?? 0,
      gender: data['gender'] ?? 'L',
      education: data['education'] ?? '',
      experience: data['experience']?.toString(),
      achivement: data['achivement']?.toString(),
      vision: data['vision'] ?? '',
      mission: data['mission'] ?? '',
      imagePath: data['imagePath']?.toString(),
    );
  }
}
