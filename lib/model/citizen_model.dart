import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CitizenModel {
  int? id;
  String name;
  String province;
  String password;
  int phone;
  int nik;
  CitizenModel({
    this.id,
    required this.name,
    required this.province,
    required this.password,
    required this.phone,
    required this.nik,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'province': province,
      'password': password,
      'noHp': phone,
      'nik': nik,
    };
  }

  factory CitizenModel.fromMap(Map<String, dynamic> map) {
    return CitizenModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      province: map['province'] as String,
      password: map['password'] as String,
      phone: map['noHp'] as int,
      nik: map['nik'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CitizenModel.fromJson(String source) =>
      CitizenModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
