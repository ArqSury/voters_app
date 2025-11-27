import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voters_app/model/firebase_model/pairs_firebase.dart';
import 'package:voters_app/model/firebase_model/president_firebase.dart';
import 'package:voters_app/model/firebase_model/vice_firebase.dart';
import 'package:voters_app/services/firebase_service.dart';

class EditDialog extends StatefulWidget {
  final PairsFirebase pair;
  final PresidenFirebase presiden;
  final ViceFirebase vice;
  final Function onSaved;

  const EditDialog({
    super.key,
    required this.pair,
    required this.presiden,
    required this.vice,
    required this.onSaved,
  });

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late TextEditingController presName;
  late TextEditingController presAge;
  late TextEditingController presEdu;
  late TextEditingController presExp;
  late TextEditingController presAch;
  late TextEditingController presVision;
  late TextEditingController presMission;
  late String presGender;

  late TextEditingController viceName;
  late TextEditingController viceAge;
  late TextEditingController viceEdu;
  late TextEditingController viceExp;
  late TextEditingController viceAch;
  late TextEditingController viceVision;
  late TextEditingController viceMission;
  late String viceGender;

  String? presImageBase64;
  String? viceImageBase64;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    presName = TextEditingController(text: widget.presiden.name);
    presAge = TextEditingController(text: widget.presiden.age.toString());
    presEdu = TextEditingController(text: widget.presiden.education);
    presExp = TextEditingController(text: widget.presiden.experience ?? "");
    presAch = TextEditingController(text: widget.presiden.achivement ?? "");
    presVision = TextEditingController(text: widget.presiden.vision);
    presMission = TextEditingController(text: widget.presiden.mission);
    presGender = widget.presiden.gender;
    presImageBase64 = widget.presiden.imageBase64;

    viceName = TextEditingController(text: widget.vice.name);
    viceAge = TextEditingController(text: widget.vice.age.toString());
    viceEdu = TextEditingController(text: widget.vice.education);
    viceExp = TextEditingController(text: widget.vice.experience ?? "");
    viceAch = TextEditingController(text: widget.vice.achivement ?? "");
    viceVision = TextEditingController(text: widget.vice.vision);
    viceMission = TextEditingController(text: widget.vice.mission);
    viceGender = widget.vice.gender;
    viceImageBase64 = widget.vice.imageBase64;
  }

  Future<void> pickImage(bool isPresident) async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;
    final bytes = await File(file.path).readAsBytes();
    final base64Str = base64Encode(bytes);
    setState(() {
      if (isPresident) {
        presImageBase64 = base64Str;
      } else {
        viceImageBase64 = base64Str;
      }
    });
  }

  Future<void> saveChanges() async {
    setState(() => loading = true);

    final updatedPres = PresidenFirebase(
      id: widget.presiden.id,
      name: presName.text,
      age: int.tryParse(presAge.text) ?? 0,
      gender: presGender,
      education: presEdu.text,
      experience: presExp.text,
      achivement: presAch.text,
      vision: presVision.text,
      mission: presMission.text,
      imageBase64: presImageBase64,
    );

    final updatedVice = ViceFirebase(
      id: widget.vice.id,
      name: viceName.text,
      age: int.tryParse(viceAge.text) ?? 0,
      gender: viceGender,
      education: viceEdu.text,
      experience: viceExp.text,
      achivement: viceAch.text,
      vision: viceVision.text,
      mission: viceMission.text,
      imageBase64: viceImageBase64,
    );

    await FirebaseService.instance.editCandidatePair(
      pair: widget.pair,
      president: updatedPres,
      vice: updatedVice,
    );
    setState(() => loading = false);
    widget.onSaved();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Edit Kandidat"),
      content: loading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : buildLayer(),
      actions: [
        TextButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          onPressed: saveChanges,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          child: const Text("Simpan"),
        ),
      ],
    );
  }

  SizedBox buildLayer() {
    return SizedBox(
      width: 450,
      child: SingleChildScrollView(
        child: Column(
          children: [
            sectionTitle("Data Presiden"),
            photoBox(presImageBase64, () => pickImage(true)),
            input("Nama", presName),
            input("Usia", presAge, number: true),
            input("Pendidikan", presEdu, maxLines: 5),
            input("Pengalaman", presExp, maxLines: 5),
            input("Prestasi", presAch, maxLines: 5),
            input("Visi", presVision, maxLines: 5),
            input("Misi", presMission, maxLines: 5),
            genderPicker("Gender", presGender, (v) {
              setState(() => presGender = v);
            }),
            Divider(height: 30),
            sectionTitle("Data Wakil Presiden"),
            photoBox(viceImageBase64, () => pickImage(false)),
            input("Nama", viceName),
            input("Usia", viceAge, number: true),
            input("Pendidikan", viceEdu, maxLines: 5),
            input("Pengalaman", viceExp, maxLines: 5),
            input("Prestasi", viceAch, maxLines: 5),
            input("Visi", viceVision, maxLines: 5),
            input("Misi", viceMission, maxLines: 5),
            genderPicker("Gender", viceGender, (v) {
              setState(() => viceGender = v);
            }),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget input(
    String label,
    TextEditingController con, {
    bool number = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: con,
        maxLines: maxLines,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget genderPicker(String label, String value, Function(String) onChanged) {
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: value,
          items: const [
            DropdownMenuItem(value: "L", child: Text("Laki-Laki")),
            DropdownMenuItem(value: "P", child: Text("Perempuan")),
          ],
          onChanged: (v) => onChanged(v!),
        ),
      ],
    );
  }

  Widget photoBox(String? base64, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundImage: base64 != null
                ? MemoryImage(base64Decode(base64))
                : null,
            child: base64 == null ? const Icon(Icons.person, size: 40) : null,
          ),
          const SizedBox(height: 6),
          const Text("Ganti Foto", style: TextStyle(color: Colors.blue)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
