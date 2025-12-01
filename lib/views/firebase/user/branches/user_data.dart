import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/model/firebase_model/citizen_firebase.dart';
import 'package:voters_app/services/firebase_service.dart';
import 'package:voters_app/views/firebase/user/login_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  final formKey = GlobalKey<FormState>();
  CitizenFirebase? citizen;
  final bool _obscureText = true;
  bool loading = true;
  File? pickedImage;
  String? selectedProvince;
  String? selectedCity;

  final Map<String, List<String>> cityByProvince = {
    "Jawa Barat": ["Bandung", "Bekasi", "Bogor", "Depok", "Cimahi"],
    "Jawa Tengah": ["Semarang", "Solo", "Magelang", "Salatiga"],
    "Jawa Timur": ["Surabaya", "Malang", "Kediri", "Blitar"],
    "DKI Jakarta": ["Jakarta Pusat", "Jakarta Barat", "Jakarta Selatan"],
  };

  @override
  void initState() {
    super.initState();
    loadCitizen();
  }

  Future<void> loadCitizen() async {
    citizen = await FirebaseService.instance.getCurrentCitizen();
    selectedProvince = citizen!.province;
    selectedCity = citizen!.city;
    setState(() => loading = false);
  }

  Future<void> pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) return;
    final bytes = await File(img.path).readAsBytes();
    final base64Image = base64Encode(bytes);
    final updated = citizen!.copyWith(imageBase64: base64Image);
    await FirebaseService.instance.updateCitizenProfile(updated);
    setState(() {
      citizen = updated;
    });
  }

  Future<void> editProfileDialog() async {
    final nameC = TextEditingController(text: citizen!.name);
    final nikC = TextEditingController(text: citizen!.nik.toString());
    final phoneC = TextEditingController(text: citizen!.phone);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          "Edit Profil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: formKey,
          child: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                spacing: 12,
                mainAxisSize: MainAxisSize.min,
                children: [
                  inputEdit(
                    labelText: 'Nama',
                    controller: nameC,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return '*Wajib Diisi';
                      }
                      return null;
                    },
                  ),
                  inputEdit(
                    labelText: 'NIK',
                    controller: nikC,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return '*Wajib Diisi';
                      } else if (v.length < 16) {
                        return 'NIK minimal 16 angka';
                      }
                      return null;
                    },
                    isNumber: true,
                  ),
                  inputEdit(
                    labelText: 'No. HP',
                    controller: phoneC,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return '*Wajib Diisi';
                      }
                      return null;
                    },
                    isPhone: true,
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedProvince,
                    decoration: InputDecoration(labelText: "Provinsi"),
                    items: cityByProvince.keys
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (v) {
                      setStateDialog(() {
                        selectedProvince = v;
                        selectedCity = null;
                      });
                    },
                    validator: (v) => v == null ? 'Pilih Provinsi' : null,
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedCity,
                    decoration: InputDecoration(labelText: "Kota"),
                    items: selectedProvince == null
                        ? []
                        : cityByProvince[selectedProvince]!
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                    onChanged: (v) {
                      setStateDialog(() {
                        selectedCity = v;
                      });
                    },
                    validator: (v) => v == null ? 'Pilih Kota' : null,
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () async {
              final updated = citizen!.copyWith(
                name: nameC.text.trim(),
                nik: int.parse(nikC.text),
                phone: phoneC.text.trim(),
                province: selectedProvince,
                city: selectedCity,
              );
              await FirebaseService.instance.updateCitizenProfile(updated);
              await loadCitizen();
              Navigator.pop(context);
              Fluttertoast.showToast(msg: "Profil diperbarui!");
            },
            child: Text("Simpan", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Future<void> changePasswordDialog() async {
    final oldPassC = TextEditingController();
    final newPassC = TextEditingController();
    final confirmPassC = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text("Ubah Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            inputEdit(
              controller: oldPassC,
              labelText: 'Kata sandi lama',
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return '*Wajib Diisi';
                } else if (v.length < 8) {
                  return 'Kata sandi minimal 8 karakter';
                }
                return null;
              },
              isPass: true,
            ),
            inputEdit(
              controller: newPassC,
              labelText: 'Kata sandi baru',
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return '*Wajib Diisi';
                } else if (v.length < 8) {
                  return 'Kata sandi minimal 8 karakter';
                }
                return null;
              },
              isPass: true,
            ),
            inputEdit(
              controller: confirmPassC,
              labelText: 'Konfirmasi kata sandi',
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return '*Wajib Diisi';
                } else if (v.length < 8) {
                  return 'Kata sandi minimal 8 karakter';
                }
                return null;
              },
              isPass: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            child: Text("Simpan", style: TextStyle(color: Colors.blue)),
            onPressed: () async {
              if (newPassC.text.trim() != confirmPassC.text.trim()) {
                Fluttertoast.showToast(msg: "Password baru tidak sama!");
                return;
              }
              if (newPassC.text.length < 8) {
                Fluttertoast.showToast(msg: "Minimal 8 karakter");
                return;
              }
              try {
                User user = FirebaseAuth.instance.currentUser!;
                final cred = EmailAuthProvider.credential(
                  email: citizen!.email,
                  password: oldPassC.text.trim(),
                );
                await user.reauthenticateWithCredential(cred);
                await user.updatePassword(newPassC.text.trim());
                Fluttertoast.showToast(msg: "Password berhasil diubah!");
                Navigator.pop(context);
              } catch (e) {
                Fluttertoast.showToast(msg: "Password lama salah!");
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    await FirebaseService.instance.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginUser()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: NewColor.cream,
      body: Stack(children: [buildBackground(), buildLayer()]),
    );
  }

  Padding buildLayer() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          topProfile(),
          SizedBox(height: 30),
          userData(),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: editProfileDialog,
            icon: Icon(Icons.edit),
            label: Text("Edit Profil", style: TextStyle(color: Colors.black)),
          ),
          SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: changePasswordDialog,
            icon: Icon(Icons.lock_reset),
            label: Text("Ubah Password", style: TextStyle(color: Colors.black)),
          ),
          SizedBox(height: 16),
          Divider(),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: logout,
            icon: Icon(Icons.logout, color: Colors.red),
            label: Text("Keluar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Card userData() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            infoTile("NIK", citizen!.nik.toString(), Icons.perm_identity),
            infoTile("Provinsi", citizen!.province, Icons.map),
            infoTile("Kota", citizen!.city, Icons.location_city),
            infoTile("No. HP", citizen!.phone, Icons.phone),
          ],
        ),
      ),
    );
  }

  Column topProfile() {
    return Column(
      children: [
        profilePhoto(),
        SizedBox(height: 10),
        Text(
          citizen!.name,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        Text(citizen!.email),
      ],
    );
  }

  GestureDetector profilePhoto() {
    return GestureDetector(
      onTap: pickImage,
      child: CircleAvatar(
        radius: 75,
        backgroundColor: Colors.white,
        backgroundImage: citizen!.imageBase64 != null
            ? MemoryImage(base64Decode(citizen!.imageBase64!))
            : const AssetImage("assets/images/logo/logo_voterson_nobg.png")
                  as ImageProvider,
      ),
    );
  }

  Container buildBackground() {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade700, Colors.red.shade300],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget inputEdit({
    TextEditingController? controller,
    String? labelText,
    String? Function(String?)? validator,
    bool isNumber = false,
    bool isPhone = false,
    bool isPass = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: Icon(isPass ? Icons.visibility_off : Icons.visibility),
      ),
      validator: validator,
      keyboardType: isNumber
          ? TextInputType.number
          : isPhone
          ? TextInputType.phone
          : null,
      obscureText: isPass ? _obscureText : false,
    );
  }

  Widget infoTile(String title, String value, IconData? icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(
        value,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
