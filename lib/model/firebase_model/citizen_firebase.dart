// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class CitizenFirebase {
  final String id;
  final String email;
  final String name;
  final String province;
  final String city;
  final int nik;
  final String phone;
  final String? imageBase64;
  final DateTime createdAt;

  CitizenFirebase({
    required this.id,
    required this.email,
    required this.name,
    required this.province,
    required this.city,
    required this.nik,
    required this.phone,
    this.imageBase64,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'province': province,
      'city': city,
      'nik': nik,
      'phone': phone,
      'imageBase64': imageBase64,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory CitizenFirebase.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return CitizenFirebase(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      province: data['province'] ?? '',
      city: data['city'] ?? '',
      nik: (data['nik'] ?? 0) is int
          ? data['nik'] as int
          : int.tryParse(data['nik'].toString()) ?? 0,
      phone: data['phone']?.toString() ?? '',
      imageBase64: data['imageBase64'],
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  CitizenFirebase copyWith({
    String? name,
    String? province,
    String? city,
    int? nik,
    String? phone,
    String? imageBase64,
  }) {
    return CitizenFirebase(
      id: id,
      email: email,
      name: name ?? this.name,
      province: province ?? this.province,
      city: city ?? this.city,
      nik: nik ?? this.nik,
      phone: phone ?? this.phone,
      imageBase64: imageBase64 ?? imageBase64,
      createdAt: createdAt,
    );
  }
}
