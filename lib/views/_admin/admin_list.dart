import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/database/db_helper.dart';
import 'package:voters_app/function/build_textformfield.dart';
import 'package:voters_app/model/president_model.dart';
import 'package:voters_app/model/vice_president_model.dart';

class AdminList extends StatefulWidget {
  const AdminList({super.key});

  @override
  State<AdminList> createState() => _AdminListState();
}

class _AdminListState extends State<AdminList> {
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

  void _showEditDialog(
    int pairId,
    PresidentModel president,
    VicePresidentModel vicePresident,
  ) {
    final editPresNameCon = TextEditingController(text: president.name);
    final editViceNameCon = TextEditingController(text: vicePresident.name);
    final editPresEduCon = TextEditingController(text: president.education);
    final editViceEduCon = TextEditingController(text: vicePresident.education);
    final editPresExpCon = TextEditingController(text: president.experience);
    final editViceExpCon = TextEditingController(
      text: vicePresident.experience,
    );
    final editPresAchiveCon = TextEditingController(text: president.achivement);
    final editViceAchiveCon = TextEditingController(
      text: vicePresident.achivement,
    );
    final editVisionCon = TextEditingController(text: president.vision);
    final editMissionCon = TextEditingController(text: president.mission);
    final editPresImageCon = TextEditingController(text: president.imageUrl);
    final editViceImageCon = TextEditingController(
      text: vicePresident.imageUrl,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text('Edit Pasangan Calon'),
          content: SingleChildScrollView(
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calon Presiden',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                BuildTextformfield(hint: 'Nama', controller: editPresNameCon),
                BuildTextformfield(hint: 'Edukasi', controller: editPresEduCon),
                BuildTextformfield(
                  hint: 'Pengalaman',
                  controller: editPresExpCon,
                ),
                BuildTextformfield(
                  hint: 'Pencapaian',
                  controller: editPresAchiveCon,
                ),
                BuildTextformfield(
                  hint: 'Foto profil',
                  controller: editPresImageCon,
                ),
                Text(
                  'Calon Wakil Presiden',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                BuildTextformfield(hint: 'Nama', controller: editViceNameCon),
                BuildTextformfield(hint: 'Edukasi', controller: editViceEduCon),
                BuildTextformfield(
                  hint: 'Pengalaman',
                  controller: editViceExpCon,
                ),
                BuildTextformfield(
                  hint: 'Pencapaian',
                  controller: editViceAchiveCon,
                ),
                BuildTextformfield(
                  hint: 'Foto Profil',
                  controller: editViceImageCon,
                ),
                Text(
                  'Visi & Misi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                BuildTextformfield(hint: 'Visi', controller: editVisionCon),
                BuildTextformfield(hint: 'Misi', controller: editMissionCon),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                final updatePresident = PresidentModel(
                  id: president.id,
                  name: editPresImageCon.text,
                  education: editPresEduCon.text,
                  experience: editPresExpCon.text,
                  achivement: editPresAchiveCon.text,
                  imageUrl: editPresImageCon.text,
                  vision: editVisionCon.text,
                  mission: editMissionCon.text,
                );
                final updateVicePresident = VicePresidentModel(
                  id: vicePresident.id,
                  name: editViceImageCon.text,
                  education: editViceEduCon.text,
                  experience: editViceExpCon.text,
                  achivement: editViceAchiveCon.text,
                  imageUrl: editViceImageCon.text,
                  vision: editVisionCon.text,
                  mission: editMissionCon.text,
                );

                await DbHelper.updateCandidatePair(
                  pairId: pairId,
                  president: updatePresident,
                  vicePresident: updateVicePresident,
                );
                Fluttertoast.showToast(
                  msg: 'Data Pasangan Calon berhasil diperbarui!',
                );

                await loadCandidates();
                if (mounted) Navigator.pop(context);
              },
              child: Text(
                'Simpan',
                style: TextStyle(color: AppColor.textButton),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text('Daftar Pasangan Calon Presiden dan Wakil Presiden'),
                Divider(),
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
        final pairId = pair['id'] ?? 0;
        return buildCard(pairId, president, vicePresident, index + 1);
      },
    );
  }

  Card buildCard(
    int pairId,
    PresidentModel president,
    VicePresidentModel vicePresident,
    int number,
  ) {
    return Card(
      color: AppColor.background,
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
              'Pasangan Calon $number',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                '${president.name} & ${vicePresident.name}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(president.vision),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      _showEditDialog(pairId, president, vicePresident);
                    },
                    icon: Icon(Icons.edit, color: AppColor.textButton),
                  ),
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

  SnackBar buildSnackbar(String text) {
    return SnackBar(
      backgroundColor: AppColor.secondary,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      content: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(
              'assets/images/logo/logo_voterson_nobg.png',
            ),
          ),
          SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}
