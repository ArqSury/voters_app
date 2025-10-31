import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/database/db_helper.dart';
import 'package:voters_app/function/build_button.dart';
import 'package:voters_app/function/build_textformfield.dart';
import 'package:voters_app/model/citizen_model.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController nikC = TextEditingController();
  final TextEditingController provC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final TextEditingController noHpC = TextEditingController();

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
            SizedBox(height: 20),
            BuildButton(
              text: 'DAFTAR',
              width: 120,
              height: 100,
              backgroundColor: AppColor.button,
              color: Colors.white,
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  final CitizenModel dataCitizen = CitizenModel(
                    name: nameC.text,
                    province: provC.text,
                    password: passC.text,
                    phone: int.parse(noHpC.text),
                    nik: int.parse(nikC.text),
                  );
                  DbHelper.registerCitizen(dataCitizen);
                  Fluttertoast.showToast(msg: 'Anda berhasil mendaftar');
                  Navigator.pop(context);
                }
              },
            ),
            SizedBox(height: 20),
            Divider(color: Colors.black),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sudah punya akun?', style: TextStyle(fontSize: 16)),
                TextButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Text('Masuk', style: TextStyle(fontSize: 16)),
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
            hint: 'Nama',
            controller: nameC,
            validator: (value) {
              if (value == null || value.isEmpty) {
                Fluttertoast.showToast(msg: 'Nama wajib diisi!');
              }
              return null;
            },
          ),
          BuildTextformfield(
            hint: 'Nomor Induk Kependudukan (NIK)',
            controller: nikC,
            validator: (value) {
              if (value == null || value.isEmpty) {
                Fluttertoast.showToast(msg: 'NIK wajib diisi!');
              }
              return null;
            },
            isNumber: true,
          ),
          BuildTextformfield(
            hint: 'Provinsi',
            controller: provC,
            validator: (value) {
              if (value == null || value.isEmpty) {
                Fluttertoast.showToast(msg: 'Provinsi wajib diisi!');
              }
              return null;
            },
          ),
          BuildTextformfield(
            hint: 'No. Hp /  Whatsapp',
            controller: noHpC,
            validator: (value) {
              if (value == null || value.isEmpty) {
                Fluttertoast.showToast(msg: 'No. Hp wajib diisi!');
              }
              return null;
            },
            isNumber: true,
          ),
          BuildTextformfield(
            hint: 'Kata Sandi',
            controller: passC,
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

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: AppColor.background,
    );
  }
}
