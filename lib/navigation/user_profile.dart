import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/database/db_helper.dart';
import 'package:voters_app/function/build_button.dart';
import 'package:voters_app/function/build_textformfield.dart';
import 'package:voters_app/model/citizen_model.dart';
import 'package:voters_app/share_preference/preference_handler.dart';
import 'package:voters_app/views/login_page.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  CitizenModel? dataUser;
  bool _isVisibility = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    int id = await PreferenceHandler.getId();
    final data = await DbHelper.getCitizenById(id);
    dataUser = data;
    setState(() {});
  }

  Future<void> _onEdit(CitizenModel citizen) async {
    final editNameC = TextEditingController(text: citizen.name);
    final editPassC = TextEditingController(text: citizen.password);
    final editNoHpC = TextEditingController(text: citizen.phone.toString());
    final res = await showDialog(
      context: context,
      builder: (context) {
        return buildEditProfile(editNameC, editNoHpC, editPassC, context);
      },
    );

    if (res == true) {
      final updated = CitizenModel(
        id: citizen.id,
        name: editNameC.text,
        province: citizen.province,
        nik: citizen.nik,
        password: editPassC.text,
        phone: int.parse(editNoHpC.text),
      );
      DbHelper.updateCitizen(updated);
      getUser();
      Fluttertoast.showToast(msg: 'Profil berhasil diganti');
    }
  }

  Future<void> _logOut() async {
    await PreferenceHandler.removeLogin();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => true,
    );
  }

  AlertDialog buildEditProfile(
    TextEditingController editNameC,
    TextEditingController editNoHpC,
    TextEditingController editPassC,
    BuildContext context,
  ) {
    return AlertDialog(
      title: Text('Ganti Profil'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          BuildTextformfield(hint: 'Nama', controller: editNameC),
          BuildTextformfield(hint: 'No. Hp', controller: editNoHpC),
          BuildTextformfield(hint: 'Password', controller: editPassC),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Kembali', style: TextStyle(color: AppColor.failed)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text('Simpan', style: TextStyle(color: AppColor.textButton)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColor.primary,
          title: Text(
            'Profil Anda',
            style: TextStyle(color: AppColor.secondary),
          ),
          actions: [
            IconButton(
              color: AppColor.secondary,
              onPressed: () {
                _onEdit(dataUser!);
              },
              icon: Icon(Icons.edit),
            ),
          ],
        ),
        body: dataUser == null
            ? Center(child: CircularProgressIndicator())
            : Stack(
                alignment: AlignmentDirectional.center,
                children: [buildBackground(), buildLayer()],
              ),
      ),
    );
  }

  SingleChildScrollView buildLayer() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 20,
          children: [
            SizedBox(height: 20),
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black)],
              ),
              child: Image(
                image: AssetImage('assets/images/logo/profil_foto.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 20),
            buildProfile(text: dataUser?.name ?? ''),
            buildProfile(text: dataUser?.nik.toString() ?? ''),
            buildProfile(text: dataUser?.province ?? ''),
            buildProfile(text: dataUser?.phone.toString() ?? ''),
            buildProfile(text: dataUser?.password ?? '', isPassword: true),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                BuildButton(
                  text: 'KEMBALI',
                  width: 140,
                  height: 50,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  fontSize: 18,
                  backgroundColor: AppColor.primary,
                  color: AppColor.secondary,
                ),
                Spacer(),
                BuildButton(
                  text: 'KELUAR',
                  width: 120,
                  height: 50,
                  onPressed: () {
                    _logOut();
                  },
                  backgroundColor: AppColor.primary,
                  color: AppColor.secondary,
                  fontSize: 18,
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildProfile({required String text, bool isPassword = false}) {
    return Container(
      height: 60,
      width: 300,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 8)],
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isPassword && _isVisibility
              ? Text('******', style: TextStyle(fontWeight: FontWeight.bold))
              : Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
          Spacer(),
          isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isVisibility = !_isVisibility;
                    });
                  },
                  icon: Icon(
                    _isVisibility ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : SizedBox(),
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
