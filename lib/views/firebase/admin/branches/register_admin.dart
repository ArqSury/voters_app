import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/services/firebase_service.dart';

class RegisterAdmin extends StatefulWidget {
  const RegisterAdmin({super.key});

  @override
  State<RegisterAdmin> createState() => _RegisterAdminState();
}

class _RegisterAdminState extends State<RegisterAdmin> {
  final _formKey = GlobalKey<FormState>();
  final nameCon = TextEditingController();
  final emailCon = TextEditingController();
  final passCon = TextEditingController();
  bool obscure = true;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    checkSuperAdmin();
  }

  Future<void> checkSuperAdmin() async {
    final admin = await FirebaseService.instance.getCurrentAdmin();
    if (admin == null || admin.isSuperAdmin == false) {
      Fluttertoast.showToast(msg: "Akses ditolak. Hanya Super Admin!");
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NewColor.redDark,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(24),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: NewColor.cream,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(blurRadius: 16, color: NewColor.gold)],
            ),
            child: buildLayer(),
          ),
        ),
      ),
    );
  }

  Form buildLayer() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            "Register Admin",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: NewColor.redLight,
            ),
          ),
          SizedBox(height: 20),
          buildInput(
            controller: nameCon,
            hint: "Nama Admin",
            validator: (v) =>
                v == null || v.isEmpty ? "Nama wajib diisi" : null,
          ),
          SizedBox(height: 16),
          buildInput(
            controller: emailCon,
            hint: "Email Admin",
            validator: (v) =>
                v == null || !v.contains("@") ? "Email tidak valid" : null,
          ),
          SizedBox(height: 16),
          buildInput(
            controller: passCon,
            hint: "Password",
            isPassword: true,
            validator: (v) =>
                v == null || v.length < 8 ? "Minimal 8 karakter" : null,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: NewColor.redLight,
              minimumSize: Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: register,
            child: Text(
              loading ? "..." : "DAFTARKAN ADMIN",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInput({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscure : false,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => obscure = !obscure),
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      await FirebaseService.instance.registerAdmin(
        email: emailCon.text.trim(),
        password: passCon.text.trim(),
        name: nameCon.text.trim(),
        isSuperAdmin: false,
      );
      Fluttertoast.showToast(
        msg: "Admin berhasil dibuat! Verifikasi email diperlukan.",
      );
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      setState(() => loading = false);
    }
  }
}
