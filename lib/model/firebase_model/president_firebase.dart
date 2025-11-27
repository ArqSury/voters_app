// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class PresidenFirebase {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String education;
  final String? experience;
  final String? achivement;
  final String vision;
  final String mission;
  final String? imageBase64;

  PresidenFirebase({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.education,
    this.experience,
    this.achivement,
    required this.vision,
    required this.mission,
    this.imageBase64,
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
      'imageBase64': imageBase64,
    };
  }

  factory PresidenFirebase.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return PresidenFirebase(
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
      imageBase64: data['imageBase64'],
    );
  }
}
