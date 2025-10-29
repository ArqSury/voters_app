import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/function/build_button.dart';
import 'package:voters_app/function/build_textformfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController passCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: AppColor.background,
            ),
            Form(
              key: _formKey,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Text(
                      'Selamat Datang',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Times New Roman',
                      ),
                    ),
                    Divider(color: Colors.black, indent: 60, endIndent: 60),
                    Text(
                      'Isi Biodata Anda',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          Text(
                            'Nama:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          BuildTextformfield(
                            hint: 'Masukan nama Anda',
                            controller: nameCon,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '*Wajib Diisi';
                              }
                              return null;
                            },
                          ),
                          Text(
                            'Kata Sandi:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          BuildTextformfield(
                            hint: 'Masukan kata sandi Anda',
                            controller: passCon,
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
                    ),
                    BuildButton(
                      text: 'MASUK',
                      width: 120,
                      height: 80,
                      backgroundColor: AppColor.button,
                      color: Colors.black,
                      fontSize: 20,
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                    Divider(color: Colors.black, height: 100),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tidak punya akun?',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: Text('Daftar', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
