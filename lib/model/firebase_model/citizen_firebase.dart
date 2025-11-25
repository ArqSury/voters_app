import 'package:cloud_firestore/cloud_firestore.dart';

class CitizenFirebase {
  final String id;
  final String email;
  final String name;
  final String province;
  final String city;
  final int nik;
  final String phone;
  final String? imagePath;
  final DateTime createdAt;

  CitizenFirebase({
    required this.id,
    required this.email,
    required this.name,
    required this.province,
    required this.city,
    required this.nik,
    required this.phone,
    this.imagePath,
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
      'imagePath': imagePath,
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
      imagePath: data['imagePath']?.toString(),
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
