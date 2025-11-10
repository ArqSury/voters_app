import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/database/db_helper.dart';
import 'package:voters_app/function/build_button.dart';
import 'package:voters_app/function/build_textformfield.dart';
import 'package:voters_app/views/_admin/admin_registration_page.dart';
import 'package:voters_app/views/main_admin.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userNameCon = TextEditingController();
  final TextEditingController passwordCon = TextEditingController();
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
      key: _formKey,
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              'Login Admin',
              style: TextStyle(fontSize: 30, fontFamily: 'Times New Roman'),
            ),
            Divider(color: Colors.black, indent: 60, endIndent: 60),
            Text(
              'Isi Biodata Anda',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 20),
            buildUserInput(),
            BuildButton(
              text: 'MASUK',
              width: 120,
              height: 60,
              backgroundColor: AppColor.primary,
              color: AppColor.secondary,
              fontSize: 20,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final data = await DbHelper.loginAdmin(
                    username: userNameCon.text,
                    password: passwordCon.text,
                  );
                  if (data != null) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainAdmin()),
                      (route) => false,
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Akun Salah'),
                          content: Text('Isi semua data Anda dengan benar!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Kembali'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
            ),
            Divider(color: Colors.black, height: 100),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Tidak punya akun?', style: TextStyle(fontSize: 16)),
                TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminRegistrationPage(),
                        ),
                      );
                    });
                  },
                  child: Text(
                    'Daftar',
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
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text(
            'Username:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          BuildTextformfield(
            hint: 'Masukan username Anda',
            controller: userNameCon,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '*Wajib Diisi';
              }
              return null;
            },
          ),
          Text(
            'Password:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          BuildTextformfield(
            hint: 'Masukan password Anda',
            controller: passwordCon,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Wajib Diisi';
              } else if (value.length < 6) {
                return 'Password minimal 6 karakter';
              }
              return null;
            },
            isPassword: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text(
                  'Lupa Kata Sandi?',
                  style: TextStyle(color: AppColor.textButton),
                ),
              ),
            ],
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
