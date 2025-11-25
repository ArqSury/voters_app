import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController nikCon = TextEditingController();
  final TextEditingController phoneCon = TextEditingController();
  final TextEditingController passCon = TextEditingController();
  bool obscureText = true;
  bool isLoading = false;

  final Map<String, List<String>> cityByProvince = {
    "Jawa Barat": ["Bandung", "Bekasi", "Bogor", "Depok", "Cimahi"],
    "Jawa Tengah": ["Semarang", "Solo", "Magelang", "Salatiga"],
    "Jawa Timur": ["Surabaya", "Malang", "Kediri", "Blitar"],
    "DKI Jakarta": ["Jakarta Pusat", "Jakarta Barat", "Jakarta Selatan"],
  };

  String? selectedProvince;
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: NewColor.cream, body: buildLayer());
  }

  Widget buildLayer() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Text(
                  'Registrasi',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Times New Roman',
                    color: NewColor.redLight,
                  ),
                ),
                Divider(color: NewColor.gold, indent: 60, endIndent: 60),
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
                          MaterialPageRoute(
                            builder: (context) => RegisterUser(),
                          ),
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
}
