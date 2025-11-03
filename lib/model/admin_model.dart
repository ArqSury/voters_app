import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AdminModel {
  int? id;
  String username;
  String password;
  AdminModel({this.id, required this.username, required this.password});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'password': password,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      id: map['id'] != null ? map['id'] as int : null,
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminModel.fromJson(String source) =>
      AdminModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AdminModel(id: $id, username: $username)';
  }
}
