import 'package:cloud_firestore/cloud_firestore.dart';

class AdminFirebase {
  final String id; // FirebaseAuth uid
  final String email;
  final String name;
  final bool isSuperAdmin;
  final DateTime createdAt;

  AdminFirebase({
    required this.id,
    required this.email,
    required this.name,
    required this.isSuperAdmin,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'isSuperAdmin': isSuperAdmin,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory AdminFirebase.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return AdminFirebase(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      isSuperAdmin: data['isSuperAdmin'] ?? false,
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
