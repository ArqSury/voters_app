import 'package:flutter/material.dart';
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

  List<Map<String, dynamic>> _candidatesPairs = [];

  @override
  void initState() {
    super.initState();
    _loadCandidates();
  }

  Future<void> _loadCandidates() async {
    final presidents = await DbHelper.getAllPresidents();
    final vps = await DbHelper.getAllVicePresidents();

    // Pair them logically by ID (you can customize pairing logic later)
    List<Map<String, dynamic>> combined = [];
    for (var i = 0; i < presidents.length; i++) {
      combined.add({
        'president': presidents[i],
        'vicePresident': i < vps.length ? vps[i] : null,
      });
    }
    setState(() {
      _candidatesPairs = combined;
    });
  }

  Future<void> _registerCandidatePair() async {
    if (!_formKey.currentState!.validate()) return;

    final president = PresidentModel(
      name: presidentNameCon.text,
      vision: visionCon.text,
      education: presEduCon.text,
    );

    final vicePresident = VicePresidentModel(
      name: vicePresidentNameCon.text,
      mission: missionCon.text,
      education: viceEduCon.text,
    );

    await DbHelper.registerPresident(president);
    await DbHelper.registerVicePresident(vicePresident);

    presidentNameCon.clear();
    vicePresidentNameCon.clear();
    visionCon.clear();
    missionCon.clear();

    await _loadCandidates();
  }

  Future<void> _deleteCandidate(int index) async {
    final pair = _candidatesPairs[index];
    final president = pair['president'] as PresidentModel?;
    final vice = pair['vicePresident'] as VicePresidentModel?;

    if (president?.id != null) {
      await DbHelper.deletePresident(president!.id!);
    }
    if (vice?.id != null) {
      await DbHelper.deleteVicePresident(vice!.id!);
    }

    await _loadCandidates();
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
                BuildTextformfield(
                  hint: 'Nama Calon Presiden',
                  controller: presidentNameCon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wajib Diisi!';
                    }
                    return null;
                  },
                ),
                BuildTextformfield(
                  hint: 'Edukasi Calon Presiden',
                  controller: presEduCon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wajib Diisi!';
                    }
                    return null;
                  },
                ),
                BuildTextformfield(
                  hint: 'Nama Calon Wakil Presiden',
                  controller: vicePresidentNameCon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wajib Diisi!';
                    }
                    return null;
                  },
                ),
                BuildTextformfield(
                  hint: 'Edukasi Calon Wakil Presiden',
                  controller: viceEduCon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wajib Diisi!';
                    }
                    return null;
                  },
                ),
                BuildTextformfield(
                  hint: 'Visi',
                  controller: visionCon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wajib Diisi!';
                    }
                    return null;
                  },
                ),
                BuildTextformfield(
                  hint: 'Misi',
                  controller: missionCon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wajib Diisi!';
                    }
                    return null;
                  },
                ),
                BuildButton(
                  text: 'Daftarkan Kandidat',
                  width: 180,
                  height: 80,
                  onPressed: _registerCandidatePair,
                ),
                Divider(color: Colors.black, height: 12),
                Text('Daftar Pasangan Kandidat Terdaftar'),
                _candidatesPairs.isEmpty
                    ? Text('Belum Ada Pasangan')
                    : buildListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _candidatesPairs.length,
      itemBuilder: (context, index) {
        final president =
            _candidatesPairs[index]['president'] as PresidentModel?;
        final vice =
            _candidatesPairs[index]['vicePresident'] as VicePresidentModel?;
        return Card(
          color: AppColor.background,
          margin: const EdgeInsets.all(12),
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(
              '${president?.name ?? ''} & ${vice?.name ?? ''}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Visi : ${president?.vision ?? ''}\n'
              'Misi : ${vice?.mission ?? ''}',
            ),
            trailing: IconButton(
              onPressed: () => _deleteCandidate(index),
              icon: Icon(Icons.delete, color: Colors.red),
            ),
          ),
        );
      },
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
