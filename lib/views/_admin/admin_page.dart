import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/database/db_helper.dart';
import 'package:voters_app/function/build_button.dart';
import 'package:voters_app/function/build_textformfield.dart';
import 'package:voters_app/model/president_model.dart';
import 'package:voters_app/model/vice_president_model.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController presidentNameCon = TextEditingController();
  final TextEditingController vicePresidentNameCon = TextEditingController();
  final TextEditingController visionCon = TextEditingController();
  final TextEditingController missionCon = TextEditingController();
  final TextEditingController presEduCon = TextEditingController();
  final TextEditingController viceEduCon = TextEditingController();
  final TextEditingController presExpCon = TextEditingController();
  final TextEditingController viceExpCon = TextEditingController();
  final TextEditingController presAchiveCon = TextEditingController();
  final TextEditingController viceAchiveCon = TextEditingController();
  final TextEditingController presImageCon = TextEditingController();
  final TextEditingController viceImageCon = TextEditingController();

  List<Map<String, dynamic>> candidatePairs = [];

  @override
  void initState() {
    super.initState();
    loadCandidates();
  }

  Future<void> loadCandidates() async {
    final data = await DbHelper.getAllPairs();
    setState(() {
      candidatePairs = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Stack(children: [buildBackground(), buildLayer()])),
    );
  }

  Form buildLayer() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              spacing: 8,
              children: [
                Text(
                  'Daftarkan Pasangan Calon Presiden dan Wakil Presiden',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                buildPresidentInput(),
                buildVPInput(),
                BuildButton(
                  text: 'Simpan',
                  width: 100,
                  height: 60,
                  backgroundColor: AppColor.primary,
                  color: AppColor.secondary,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final pId = PresidentModel(
                        name: presidentNameCon.text,
                        education: presEduCon.text,
                        vision: visionCon.text,
                        mission: missionCon.text,
                        experience: presExpCon.text,
                        achivement: presAchiveCon.text,
                        imageUrl: presImageCon.text,
                      );
                      final vId = VicePresidentModel(
                        name: vicePresidentNameCon.text,
                        education: viceEduCon.text,
                        vision: visionCon.text,
                        mission: missionCon.text,
                        experience: viceExpCon.text,
                        achivement: viceAchiveCon.text,
                        imageUrl: viceImageCon.text,
                      );
                      await DbHelper.addCandidatePair(
                        president: pId,
                        vicePresident: vId,
                      );
                      Fluttertoast.showToast(
                        msg: 'Pasangan berhasil didaftarkan',
                      );
                      presidentNameCon.clear();
                      vicePresidentNameCon.clear();
                      presEduCon.clear();
                      viceEduCon.clear();
                      presExpCon.clear();
                      viceExpCon.clear();
                      presAchiveCon.clear();
                      viceAchiveCon.clear();
                      presImageCon.clear();
                      viceImageCon.clear();
                      visionCon.clear();
                      missionCon.clear();

                      await loadCandidates();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildPresidentInput() {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Calon Presiden'),
          BuildTextformfield(
            hint: 'Nama',
            controller: presidentNameCon,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Wajib Diisi';
              }
              return null;
            },
          ),
          BuildTextformfield(
            hint: 'Edukasi',
            controller: presEduCon,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Wajib Diisi';
              }
              return null;
            },
          ),
          BuildTextformfield(hint: 'Pengalaman', controller: presExpCon),
          BuildTextformfield(hint: 'Pencapaian', controller: presAchiveCon),
          BuildTextformfield(hint: 'Foto profil', controller: presImageCon),
          BuildTextformfield(
            hint: 'Visi',
            controller: visionCon,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Wajib Diisi';
              }
              return null;
            },
          ),
          BuildTextformfield(
            hint: 'Misi',
            controller: missionCon,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Wajib Diisi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Container buildVPInput() {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Calon Wakil Presiden'),
          BuildTextformfield(
            hint: 'Nama',
            controller: vicePresidentNameCon,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Wajib Diisi';
              }
              return null;
            },
          ),
          BuildTextformfield(
            hint: 'Edukasi',
            controller: viceEduCon,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Wajib Diisi';
              }
              return null;
            },
          ),
          BuildTextformfield(hint: 'Pengalaman', controller: viceExpCon),
          BuildTextformfield(hint: 'Pencapaian', controller: viceAchiveCon),
          BuildTextformfield(hint: 'Foto profil', controller: viceImageCon),
          BuildTextformfield(
            hint: 'Visi',
            controller: visionCon,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Wajib Diisi';
              }
              return null;
            },
          ),
          BuildTextformfield(
            hint: 'Misi',
            controller: missionCon,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Wajib Diisi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: AppColor.background,
    );
  }
}
