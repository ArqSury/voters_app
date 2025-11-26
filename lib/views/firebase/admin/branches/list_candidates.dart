import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voters_app/model/firebase_model/president_firebase.dart';
import 'package:voters_app/model/firebase_model/vice_firebase.dart';
import 'package:voters_app/model/firebase_model/pairs_firebase.dart';
import 'package:voters_app/services/firebase_service.dart';

class ListCandidates extends StatefulWidget {
  const ListCandidates({super.key});

  @override
  State<ListCandidates> createState() => _ListCandidatesState();
}

class _ListCandidatesState extends State<ListCandidates> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<PairsFirebase>>(
        stream: FirebaseService.instance.watchAllPairs(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final pairs = snap.data!;
          if (pairs.isEmpty) {
            return Center(child: Text("Belum ada kandidat"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: pairs.length,
            itemBuilder: (context, i) => CandidateCard(pair: pairs[i]),
          );
        },
      ),
    );
  }
}

class CandidateCard extends StatefulWidget {
  final PairsFirebase pair;
  const CandidateCard({super.key, required this.pair});

  @override
  State<CandidateCard> createState() => _CandidateCardState();
}

class _CandidateCardState extends State<CandidateCard> {
  PresidenFirebase? pres;
  ViceFirebase? vice;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final presDoc = await FirebaseFirestore.instance
        .collection("presidents")
        .doc(widget.pair.presidentId)
        .get();
    final viceDoc = await FirebaseFirestore.instance
        .collection("vice_presidents")
        .doc(widget.pair.viceId)
        .get();
    setState(() {
      pres = PresidenFirebase.fromDoc(presDoc);
      vice = ViceFirebase.fromDoc(viceDoc);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading || pres == null || vice == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              "Pasangan #${widget.pair.number}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                memberAvatar(title: "Presiden", path: pres!.imagePath),
                memberAvatar(title: "Wakil", path: vice!.imagePath),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "${pres!.name} & ${vice!.name}",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            Text(widget.pair.description ?? "-", textAlign: TextAlign.center),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  icon: Icon(Icons.edit),
                  label: Text("Edit"),
                  onPressed: () => editDialog(context),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  icon: Icon(Icons.delete),
                  label: Text("Hapus"),
                  onPressed: () => deleteConfirm(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget memberAvatar({required String title, required String? path}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 38,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: path != null ? FileImage(File(path)) : null,
          child: path == null ? const Icon(Icons.person, size: 38) : null,
        ),
        SizedBox(height: 6),
        Text(title),
      ],
    );
  }

  void deleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Hapus Kandidat?"),
        content: Text("Data presiden & wakil akan dihapus."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseService.instance.deleteCandidatePair(
                widget.pair.id,
              );
            },
            child: Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> editDialog(BuildContext context) async {
    final presName = TextEditingController(text: pres!.name);
    final presAge = TextEditingController(text: pres!.age.toString());
    final presEdu = TextEditingController(text: pres!.education);
    final viceName = TextEditingController(text: vice!.name);
    final viceAge = TextEditingController(text: vice!.age.toString());
    final viceEdu = TextEditingController(text: vice!.education);
    String? newPresImage = pres!.imagePath;
    String? newViceImage = vice!.imagePath;
    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState2) => AlertDialog(
          title: Text("Edit Kandidat"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text("Foto Presiden"),
                imagePickerBox(
                  currentPath: newPresImage,
                  onPick: () async {
                    final x = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (x != null) {
                      newPresImage = x.path;
                      setState2(() {});
                    }
                  },
                ),
                TextField(
                  controller: presName,
                  decoration: InputDecoration(labelText: "Nama Presiden"),
                ),
                TextField(
                  controller: presAge,
                  decoration: InputDecoration(labelText: "Umur Presiden"),
                ),
                TextField(
                  controller: presEdu,
                  decoration: InputDecoration(labelText: "Pendidikan"),
                ),
                SizedBox(height: 20),
                const Text("Foto Wakil"),
                imagePickerBox(
                  currentPath: newViceImage,
                  onPick: () async {
                    final x = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (x != null) {
                      newViceImage = x.path;
                      setState2(() {});
                    }
                  },
                ),
                TextField(
                  controller: viceName,
                  decoration: const InputDecoration(labelText: "Nama Wakil"),
                ),
                TextField(
                  controller: viceAge,
                  decoration: const InputDecoration(labelText: "Umur Wakil"),
                ),
                TextField(
                  controller: viceEdu,
                  decoration: const InputDecoration(labelText: "Pendidikan"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                final updatedPres = PresidenFirebase(
                  id: pres!.id,
                  name: presName.text,
                  age: int.parse(presAge.text),
                  gender: pres!.gender,
                  education: presEdu.text,
                  experience: pres!.experience,
                  achivement: pres!.achivement,
                  mission: pres!.mission,
                  vision: pres!.vision,
                  imagePath: newPresImage,
                );
                final updatedVice = ViceFirebase(
                  id: vice!.id,
                  name: viceName.text,
                  age: int.parse(viceAge.text),
                  gender: vice!.gender,
                  education: viceEdu.text,
                  experience: vice!.experience,
                  achivement: vice!.achivement,
                  mission: vice!.mission,
                  vision: vice!.vision,
                  imagePath: newViceImage,
                );
                await FirebaseService.instance.editCandidatePair(
                  pair: widget.pair,
                  president: updatedPres,
                  vice: updatedVice,
                );
                Navigator.pop(context);
              },
              child: Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }

  Widget imagePickerBox({
    required String? currentPath,
    required Function() onPick,
  }) {
    return GestureDetector(
      onTap: onPick,
      child: Container(
        height: 100,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
          image: currentPath != null
              ? DecorationImage(
                  image: FileImage(File(currentPath)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: currentPath == null ? Center(child: Text("Pilih Foto")) : null,
      ),
    );
  }
}
