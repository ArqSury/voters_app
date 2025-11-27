import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voters_app/services/firebase_service.dart';

class AddCandidates extends StatefulWidget {
  const AddCandidates({super.key});

  @override
  State<AddCandidates> createState() => _AddCandidatesState();
}

class _AddCandidatesState extends State<AddCandidates> {
  bool loading = false;
  String? presImageBase64;
  String? viceImageBase64;

  final presName = TextEditingController();
  final presAge = TextEditingController();
  final presEdu = TextEditingController();
  final presExp = TextEditingController();
  final presAch = TextEditingController();
  final presVision = TextEditingController();
  final presMission = TextEditingController();
  String presGender = "L";

  final viceName = TextEditingController();
  final viceAge = TextEditingController();
  final viceEdu = TextEditingController();
  final viceExp = TextEditingController();
  final viceAch = TextEditingController();
  final viceVision = TextEditingController();
  final viceMission = TextEditingController();
  String viceGender = "L";

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

  Future<void> saveCandidate() async {
    if (presImageBase64 == null || viceImageBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto presiden & wakil wajib diisi.")),
      );
      return;
    }
    if (presName.text.isEmpty || viceName.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Nama wajib diisi.")));
      return;
    }
    setState(() => loading = true);
    try {
      final pres = await FirebaseService.instance.addPresident(
        name: presName.text,
        age: int.parse(presAge.text),
        gender: presGender,
        education: presEdu.text,
        experience: presExp.text,
        achivement: presAch.text,
        vision: presVision.text,
        mission: presMission.text,
        imageBase64: presImageBase64,
      );
      final vice = await FirebaseService.instance.addVice(
        name: viceName.text,
        age: int.parse(viceAge.text),
        gender: viceGender,
        education: viceEdu.text,
        experience: viceExp.text,
        achivement: viceAch.text,
        vision: viceVision.text,
        mission: viceMission.text,
        imageBase64: viceImageBase64,
      );
      await FirebaseService.instance.addCandidatePair(
        president: pres,
        vice: vice,
      );
      Fluttertoast.showToast(msg: 'Kandidat berhasil didaftarkan');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : buildLayer(),
    );
  }

  SingleChildScrollView buildLayer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle("Data Presiden"),
          SizedBox(height: 10),
          buildPhotoPicker(
            base64: presImageBase64,
            onTap: () => pickImage(true),
          ),
          SizedBox(height: 16),
          genderPicker(
            "Gender",
            presGender,
            (v) => setState(() => presGender = v),
          ),
          SizedBox(height: 10),
          input("Nama", presName),
          SizedBox(height: 10),
          input("Usia", presAge, type: TextInputType.number),
          SizedBox(height: 10),
          input("Pendidikan", presEdu, maxLines: 5),
          SizedBox(height: 10),
          input("Pengalaman", presExp, maxLines: 5),
          SizedBox(height: 10),
          input("Prestasi", presAch, maxLines: 5),
          SizedBox(height: 10),
          input("Visi", presVision, maxLines: 5),
          SizedBox(height: 10),
          input("Misi", presMission, maxLines: 5),
          SizedBox(height: 30),
          Divider(),
          SizedBox(height: 20),

          sectionTitle("Data Wakil Presiden"),
          SizedBox(height: 10),
          buildPhotoPicker(
            base64: viceImageBase64,
            onTap: () => pickImage(false),
          ),
          SizedBox(height: 16),
          genderPicker(
            "Gender",
            viceGender,
            (v) => setState(() => viceGender = v),
          ),
          SizedBox(height: 10),
          input("Nama", viceName),
          SizedBox(height: 10),
          input("Usia", viceAge, type: TextInputType.number),
          SizedBox(height: 10),
          input("Pendidikan", viceEdu, maxLines: 5),
          SizedBox(height: 10),
          input("Pengalaman", viceExp, maxLines: 5),
          SizedBox(height: 10),
          input("Prestasi", viceAch, maxLines: 5),
          SizedBox(height: 10),
          input("Visi", viceVision, maxLines: 5),
          SizedBox(height: 10),
          input("Misi", viceMission, maxLines: 5),
          SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: saveCandidate,
            child: Text(
              "SIMPAN KANDIDAT",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Center buildPhotoPicker({
    required String? base64,
    required VoidCallback onTap,
  }) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: base64 != null
              ? MemoryImage(base64Decode(base64))
              : null,
          child: base64 == null
              ? Icon(Icons.camera_alt, size: 40, color: Colors.black54)
              : null,
        ),
      ),
    );
  }

  Widget genderPicker(String label, String value, Function(String) onChange) {
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 10),
        DropdownButton(
          value: value,
          items: const [
            DropdownMenuItem(value: "L", child: Text("Laki-Laki")),
            DropdownMenuItem(value: "P", child: Text("Perempuan")),
          ],
          onChanged: (v) => onChange(v as String),
        ),
      ],
    );
  }

  Widget sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget input(
    String label,
    TextEditingController con, {
    TextInputType type = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: con,
      keyboardType: type,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
