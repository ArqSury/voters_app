import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/database/db_helper.dart';
import 'package:voters_app/function/build_button.dart';
import 'package:voters_app/function/build_textformfield.dart';
import 'package:voters_app/model/admin_model.dart';
import 'package:voters_app/views/_admin/admin_login_page.dart';

class AdminRegistrationPage extends StatefulWidget {
  const AdminRegistrationPage({super.key});

  @override
  State<AdminRegistrationPage> createState() => _AdminRegistrationPageState();
}

class _AdminRegistrationPageState extends State<AdminRegistrationPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController userNameC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [buildBackground(), buildLayer(context)]),
      ),
    );
  }

  Form buildLayer(BuildContext context) {
    return Form(
      key: _formkey,
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Registrasi',
              style: TextStyle(fontSize: 30, fontFamily: 'Times New Roman'),
            ),
            Divider(color: Colors.black, indent: 80, endIndent: 80),
            SizedBox(height: 12),
            buildUserInput(),
            SizedBox(height: 60),
            BuildButton(
              text: 'DAFTAR',
              width: 120,
              height: 60,
              backgroundColor: AppColor.primary,
              color: AppColor.secondary,
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  final AdminModel dataAdmin = AdminModel(
                    username: userNameC.text,
                    password: passwordC.text,
                  );
                  DbHelper.registerAdmin(dataAdmin);
                  ScaffoldMessenger.of(context).showSnackBar(buildSnackbar());
                  Navigator.pop(context);
                }
              },
            ),
            SizedBox(height: 20),
            Divider(color: Colors.black),
            SizedBox(height: 160),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sudah jadi admin?', style: TextStyle(fontSize: 16)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminLoginPage()),
                    );
                  },
                  child: Text(
                    'Masuk',
                    style: TextStyle(fontSize: 16, color: AppColor.textButton),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildUserInput() {
    return Container(
      margin: const EdgeInsets.all(12),
      width: double.infinity,
      child: Column(
        spacing: 16,
        children: [
          BuildTextformfield(
            hint: 'Username',
            controller: userNameC,
            validator: (value) {
              if (value == null || value.isEmpty) {
                Fluttertoast.showToast(msg: 'Nama wajib diisi!');
              }
              return null;
            },
          ),
          BuildTextformfield(
            hint: 'Kata Sandi',
            controller: passwordC,
            validator: (value) {
              if (value == null || value.isEmpty) {
                Fluttertoast.showToast(msg: 'Kata sandi wajib diisi!');
              } else if (value.length < 6) {
                Fluttertoast.showToast(msg: 'Kata sandi minimal 6 karakter');
              }
              return null;
            },
            isPassword: true,
          ),
        ],
      ),
    );
  }

  SnackBar buildSnackbar() {
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
          Text('Anda berhasil mendaftar!'),
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
