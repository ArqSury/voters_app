import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voters_app/database/db_helper.dart';

class BuildForgotpassword extends StatefulWidget {
  const BuildForgotpassword({super.key});

  @override
  State<BuildForgotpassword> createState() => _BuildForgotpasswordState();
}

class _BuildForgotpasswordState extends State<BuildForgotpassword> {
  final nameCon = TextEditingController();
  final nikCon = TextEditingController();
  final phoneCon = TextEditingController();
  final newPassCon = TextEditingController();
  bool verified = false;
  int? userId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Lupa Kata Sandi'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!verified) ...[
              TextField(
                controller: nameCon,
                decoration: InputDecoration(labelText: 'Nama Lengkap'),
              ),
              TextField(
                controller: nikCon,
                decoration: InputDecoration(labelText: 'NIK'),
              ),
              TextField(
                controller: phoneCon,
                decoration: InputDecoration(labelText: 'Nomor Telepon'),
              ),
            ] else ...[
              TextField(
                controller: newPassCon,
                decoration: InputDecoration(labelText: 'Kata Sandi Baru'),
                obscureText: true,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Batal'),
        ),
        TextButton(
          onPressed: () async {
            if (!verified) {
              final user = await DbHelper.verifyCitizenIdentity(
                name: nameCon.text,
                nik: nikCon.text,
                phone: phoneCon.text,
              );

              if (user != null) {
                setState(() {
                  verified = true;
                  userId = user['id'];
                });
              } else {
                Fluttertoast.showToast(msg: 'Data tidak sama! Ulangi lagi!');
              }
            } else {
              if (newPassCon.text.length < 6) {
                Fluttertoast.showToast(msg: 'Password minimal 6 karakter');
                return;
              }

              await DbHelper.updateCitizenPassword(
                id: userId!,
                newPassword: newPassCon.text,
              );
              Fluttertoast.showToast(msg: 'Password berhasil diperbarui!');
              Navigator.pop(context);
            }
          },
          child: Text(verified ? 'Simpan' : 'Verifikasi'),
        ),
      ],
    );
  }
}
