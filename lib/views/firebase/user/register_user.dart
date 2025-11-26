import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/services/firebase_service.dart';

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
                SizedBox(height: 40),
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
                  'Pendaftaran akun',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: NewColor.redLight,
                  ),
                ),
                SizedBox(height: 20),
                userInput(
                  hintText: 'Nama',
                  controller: nameCon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Wajib Diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                userInput(
                  hintText: 'Nomor Induk Kependudukan (NIK)',
                  controller: nikCon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Wajib Diisi';
                    } else if (value.length < 16) {
                      return 'NIK minimal 16 angka';
                    }
                    return null;
                  },
                  isNumber: true,
                ),
                SizedBox(height: 20),
                userInput(
                  hintText: 'Email',
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
                  hintText: 'Kata Sandi',
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
                SizedBox(height: 20),
                userInput(
                  hintText: 'No. Hp',
                  controller: phoneCon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Wajib Diisi';
                    }
                    return null;
                  },
                  isPhone: true,
                ),
                SizedBox(height: 20),
                dropProvince(),
                SizedBox(height: 20),
                dropCity(),
                SizedBox(height: 20),
                buttonLogout(),
                SizedBox(height: 20),
                Divider(color: NewColor.gold, indent: 20, endIndent: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum punya akun?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Masuk',
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

  DropdownButtonFormField<String> dropCity() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        fillColor: Colors.white,
        filled: true,
      ),
      value: selectedCity,
      hint: const Text("Pilih Kota"),
      items: selectedProvince == null
          ? []
          : cityByProvince[selectedProvince]!
                .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                .toList(),
      onChanged: (value) {
        setState(() => selectedCity = value);
      },
      validator: (v) => v == null ? "Pilih kota" : null,
    );
  }

  DropdownButtonFormField<String> dropProvince() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        fillColor: Colors.white,
        filled: true,
      ),
      value: selectedProvince,
      hint: const Text("Pilih Provinsi"),
      items: cityByProvince.keys
          .map((prov) => DropdownMenuItem(value: prov, child: Text(prov)))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedProvince = value;
          selectedCity = null;
        });
      },
      validator: (v) => v == null ? "Pilih provinsi" : null,
    );
  }

  ElevatedButton buttonLogout() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: NewColor.redLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      onPressed: () async {
        if (!_formKey.currentState!.validate()) return;
        if (selectedProvince == null || selectedCity == null) {
          Fluttertoast.showToast(msg: "Pilih provinsi dan kota");
          return;
        }
        setState(() => isLoading = true);
        try {
          await FirebaseService.instance.registerCitizen(
            email: emailCon.text.trim(),
            password: passCon.text.trim(),
            name: nameCon.text.trim(),
            province: selectedProvince!,
            city: selectedCity!,
            nik: int.parse(nikCon.text),
            phone: phoneCon.text,
          );
          Fluttertoast.showToast(msg: "Registrasi berhasil!");
          if (mounted) Navigator.pop(context);
        } catch (e) {
          Fluttertoast.showToast(msg: e.toString());
        } finally {
          if (mounted) setState(() => isLoading = false);
        }
      },
      child: Text(
        isLoading ? '.....' : 'DAFTAR',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget userInput({
    TextEditingController? controller,
    String? hintText,
    String? Function(String?)? validator,
    bool isPassword = false,
    bool isNumber = false,
    bool isPhone = false,
  }) {
    return TextFormField(
      keyboardType: isNumber
          ? TextInputType.number
          : isPhone
          ? TextInputType.phone
          : null,
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
