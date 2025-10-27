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
  final TextEditingController numbC = TextEditingController();
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    boxShadow: [BoxShadow(blurRadius: 12, color: Colors.black)],
                  ),
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage(
                          'assets/images/logo/logoapp_final.png',
                        ),
                        height: 120,
                        width: 200,
                      ),
                      Text(
                        'Selamat Datang',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Text('Nama:', style: TextStyle(fontSize: 16)),
                            UserInputFunction(
                              hint: 'Masukan Nama',
                              textController: nameC,
                            ),
                            Text('Provinsi:', style: TextStyle(fontSize: 16)),
                            UserInputFunction(
                              hint: 'Masukan provinsi Anda',
                              textController: provC,
                            ),
                            Text('No.Hp:', style: TextStyle(fontSize: 16)),
                            UserInputFunction(
                              hint: 'Masukan No.Hp / Whatsapp Anda',
                              textController: numbC,
                              isNumber: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      ButtonFunction(
                        buttonText: 'Masuk',
                        buttonWidth: 100,
                        buttonHeight: 60,
                        color: Colors.white,
                        backgroundColor: Colors.red,
                        pressButton: () {
                          setState(() {});
                        },
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
