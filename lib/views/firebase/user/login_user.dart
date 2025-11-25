import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/services/firebase_service.dart';
import 'package:voters_app/views/firebase/user/register_user.dart';
import 'package:voters_app/views/firebase/user/user_center.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController passCon = TextEditingController();
  bool obscureText = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [buildBackground(), buildLayer()],
      ),
    );
  }

  Widget buildLayer() {
    return Form(
      key: _formKey,
      child: Container(
        height: 600,
        width: double.infinity,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(16),
        decoration: boxDecor(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selamat Datang',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Times New Roman',
                  color: NewColor.redLight,
                ),
              ),
              Divider(color: NewColor.gold, indent: 20, endIndent: 20),
              Text(
                'Masukkan biodata Anda',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: NewColor.redLight,
                ),
              ),
              SizedBox(height: 40),
              userInput(
                hintText: 'Masukan email anda',
                controller: emailCon,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Wajib Diisi';
                  } else if (!value.contains('@')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              userInput(
                hintText: 'Masukan kata sandi anda',
                controller: passCon,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Wajib Diisi';
                  } else if (value.length < 8) {
                    return 'Kata sandi minimal 8 karakter';
                  }
                  return null;
                },
                isPassword: true,
              ),
              SizedBox(height: 40),
              buttonLogin(),
              SizedBox(height: 40),
              Divider(color: NewColor.gold, indent: 20, endIndent: 20),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Belum punya akun?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterUser()),
                      );
                    },
                    child: Text(
                      'Daftar',
                      style: TextStyle(color: NewColor.redLight),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton buttonLogin() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: NewColor.redLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) return;
        setState(() => isLoading = true);
        try {
          await FirebaseService.instance.loginCitizen(
            email: emailCon.text.trim(),
            password: passCon.text.trim(),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => UserCenter()),
            (route) => false,
          );
        } catch (e) {
          Fluttertoast.showToast(msg: e.toString());
        } finally {
          if (mounted) setState(() => isLoading = false);
        }
      },
      child: Text(
        isLoading ? '.....' : 'MASUK',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget userInput({
    TextEditingController? controller,
    String? hintText,
    String? Function(String?)? validator,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isPassword ? obscureText : false,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.black),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  obscureText = !obscureText;
                  setState(() {});
                },
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              )
            : null,
      ),
    );
  }

  BoxDecoration boxDecor() {
    return BoxDecoration(
      color: NewColor.cream,
      borderRadius: BorderRadius.all(Radius.circular(12)),
      boxShadow: [BoxShadow(blurRadius: 20, color: NewColor.gold)],
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: NewColor.redDark,
    );
  }
}
