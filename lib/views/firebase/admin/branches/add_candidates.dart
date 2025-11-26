import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voters_app/services/firebase_service.dart';

class AddCandidates extends StatefulWidget {
  const AddCandidates({super.key});

  @override
  State<AddCandidates> createState() => _AddCandidatesState();
}

class _AddCandidatesState extends State<AddCandidates> {
  File? presImage;
  File? viceImage;
  bool loading = false;

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

  Future<File?> pickImage() async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    return x != null ? File(x.path) : null;
  }

  Future<void> saveCandidate() async {
    if (presName.text.isEmpty ||
        presAge.text.isEmpty ||
        viceName.text.isEmpty ||
        viceAge.text.isEmpty ||
        presImage == null ||
        viceImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data & foto kandidat.")),
      );
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
        imagePath: presImage!.path,
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
        imagePath: viceImage!.path,
      );
      await FirebaseService.instance.addCandidatePair(
        president: pres,
        vice: vice,
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kandidat berhasil disimpan!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => loading = false);
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
          Center(
            child: pickPhotoBox(
              file: presImage,
              onTap: () async {
                final img = await pickImage();
                if (img != null) setState(() => presImage = img);
              },
            ),
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
          input("Pendidikan", presEdu),
          SizedBox(height: 10),
          input("Pengalaman", presExp),
          SizedBox(height: 10),
          input("Prestasi", presAch),
          SizedBox(height: 10),
          input("Visi", presVision, maxLines: 3),
          SizedBox(height: 10),
          input("Misi", presMission, maxLines: 3),
          SizedBox(height: 30),
          Divider(),
          SizedBox(height: 20),

          sectionTitle("Data Wakil Presiden"),
          SizedBox(height: 10),
          Center(
            child: pickPhotoBox(
              file: viceImage,
              onTap: () async {
                final img = await pickImage();
                if (img != null) setState(() => viceImage = img);
              },
            ),
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
          input("Pendidikan", viceEdu),
          SizedBox(height: 10),
          input("Pengalaman", viceExp),
          SizedBox(height: 10),
          input("Prestasi", viceAch),
          SizedBox(height: 10),
          input("Visi", viceVision, maxLines: 3),
          SizedBox(height: 10),
          input("Misi", viceMission, maxLines: 3),

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

  Widget pickPhotoBox({required File? file, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        width: 130,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
          image: file != null
              ? DecorationImage(image: FileImage(file), fit: BoxFit.cover)
              : null,
        ),
        child: file == null ? const Icon(Icons.camera_alt, size: 36) : null,
      ),
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
