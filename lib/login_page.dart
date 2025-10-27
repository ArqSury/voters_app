import 'package:flutter/material.dart';
import 'package:voters_app/functions/button_function.dart';
import 'package:voters_app/functions/user_input_function.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController provC = TextEditingController();
  final TextEditingController nikC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            Stack(
              alignment: AlignmentGeometry.bottomCenter,
              children: [
                Container(
                  color: Colors.red,
                  height: 829,
                  width: double.infinity,
                ),
                Container(
                  height: 740,
                  width: 360,
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    boxShadow: [BoxShadow(blurRadius: 12, color: Colors.black)],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Selamat Datang',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                      Divider(color: Colors.black),
                      Text(
                        'Isi Biodata Anda',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Text(
                              'Nama:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            UserInputFunction(
                              hint: 'Nama',
                              textController: nameC,
                              textValidator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '*Wajib diisi';
                                }
                                return null;
                              },
                            ),
                            Text(
                              'Provinsi:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            UserInputFunction(
                              hint: 'Provinsi',
                              textController: provC,
                              textValidator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '*Wajib diisi';
                                }
                                return null;
                              },
                            ),
                            Text(
                              'ID:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            UserInputFunction(
                              hint: 'Nomor Induk Kependudukan (NIK)',
                              textController: nikC,
                              isNumber: true,
                              textValidator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '*Wajib diisi';
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
                            UserInputFunction(
                              hint: 'Kata Sandi',
                              textController: passC,
                              isPassword: true,
                              textValidator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '*Wajib diisi';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      ButtonFunction(
                        buttonText: 'Masuk',
                        buttonWidth: 50,
                        buttonHeight: 50,
                        color: Colors.white,
                        backgroundColor: Colors.red,
                        pressButton: () {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 30),
                      Divider(color: Colors.black),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Tidak punya akun?'),
                          TextButton(
                            onPressed: () {
                              setState(() {});
                            },
                            child: Text(
                              'Daftar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
