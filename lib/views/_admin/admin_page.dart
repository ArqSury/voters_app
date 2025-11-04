import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/database/db_helper.dart';
import 'package:voters_app/function/build_button.dart';
import 'package:voters_app/function/build_textformfield.dart';
import 'package:voters_app/model/president_model.dart';
import 'package:voters_app/model/vice_president_model.dart';
import 'package:voters_app/views/_admin/admin_login_page.dart';

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

  Future<void> deleteCandidate(int pairId) async {
    await DbHelper.deleteCandidatePair(pairId);
    await loadCandidates();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pendaftaran Kandidat'),
          centerTitle: true,
          backgroundColor: AppColor.background,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLoginPage()),
                  (route) => false,
                );
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: Stack(children: [buildBackground(), buildLayer()]),
      ),
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
                  height: 80,
                  backgroundColor: AppColor.button,
                  color: Colors.black,
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
                Divider(height: 20),
                Text('Daftar Pasangan Calon Presiden dan Wakil Presiden'),
                candidatePairs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Belum Ada Pasangan yang Terdaftar')],
                        ),
                      )
                    : buildListCandidates(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView buildListCandidates() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: candidatePairs.length,
      itemBuilder: (context, index) {
        final pair = candidatePairs[index];
        final president = PresidentModel.fromMap(pair['president']);
        final vicePresident = VicePresidentModel.fromMap(
          pair['vice_president'],
        );
        return buildCard(pair['id'], president, vicePresident);
      },
    );
  }

  Card buildCard(
    int pairId,
    PresidentModel president,
    VicePresidentModel vicePresident,
  ) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pasangan Calon ${candidatePairs[pairId]}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                '${president.name} & ${vicePresident.name}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(president.vision),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await deleteCandidate(pairId);
                      Fluttertoast.showToast(msg: 'Pasangan dihapus');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildPresidentInput() {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      child: Column(
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.background, AppColor.primary, AppColor.secondary],
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
        ),
      ),
    );
  }
}
