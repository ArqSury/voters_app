import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/function/edit_dialog.dart';
import 'package:voters_app/model/firebase_model/pairs_firebase.dart';
import 'package:voters_app/model/firebase_model/president_firebase.dart';
import 'package:voters_app/model/firebase_model/vice_firebase.dart';
import 'package:voters_app/services/firebase_service.dart';

class ListCandidates extends StatefulWidget {
  const ListCandidates({super.key});

  @override
  State<ListCandidates> createState() => _ListCandidatesState();
}

class _ListCandidatesState extends State<ListCandidates> {
  List<PairsFirebase> pairs = [];
  Map<String, PresidenFirebase> presidents = {};
  Map<String, ViceFirebase> vices = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCandidates();
  }

  Future<void> loadCandidates() async {
    setState(() => loading = true);
    final loadedPairs = await FirebaseService.instance.getAllPairs();
    final tempPres = <String, PresidenFirebase>{};
    final tempVice = <String, ViceFirebase>{};
    for (var pair in loadedPairs) {
      final presSnap = await FirebaseService.instance.firestore
          .collection("presidents")
          .doc(pair.presidentId)
          .get();
      if (presSnap.exists) {
        tempPres[pair.presidentId] = PresidenFirebase.fromDoc(presSnap);
      }

      final viceSnap = await FirebaseService.instance.firestore
          .collection("vice_presidents")
          .doc(pair.viceId)
          .get();
      if (viceSnap.exists) {
        tempVice[pair.viceId] = ViceFirebase.fromDoc(viceSnap);
      }
    }
    setState(() {
      pairs = loadedPairs;
      presidents = tempPres;
      vices = tempVice;
      loading = false;
    });
  }

  Future<void> deleteCandidate(String pairId) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Hapus Kandidat?"),
        content: Text("Data Presiden + Wakil akan dihapus permanen."),
        actions: [
          TextButton(
            child: Text("Batal"),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: Text("Hapus"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await FirebaseService.instance.deleteCandidatePair(pairId);
    loadCandidates();
  }

  void showEditDialog(PairsFirebase pair) {
    final pres = presidents[pair.presidentId]!;
    final vice = vices[pair.viceId]!;
    showDialog(
      context: context,
      builder: (_) => EditDialog(
        pair: pair,
        presiden: pres,
        vice: vice,
        onSaved: () => loadCandidates(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NewColor.cream,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : pairs.isEmpty
          ? const Center(child: Text("Belum ada kandidat."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pairs.length,
              itemBuilder: (_, i) {
                final pair = pairs[i];
                final pres = presidents[pair.presidentId];
                final vice = vices[pair.viceId];
                if (pres == null || vice == null) {
                  return const SizedBox();
                }
                return candidateCard(pair, pres, vice);
              },
            ),
    );
  }

  Widget candidateCard(
    PairsFirebase pair,
    PresidenFirebase pres,
    ViceFirebase vice,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Pasangan #${pair.number}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                candidatePhotoColumn("Presiden", pres.name, pres.imageBase64),
                candidatePhotoColumn("Wakil", vice.name, vice.imageBase64),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  label: Text("Edit", style: TextStyle(color: Colors.blue)),
                  onPressed: () => showEditDialog(pair),
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black,
                    elevation: 4,
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.delete, color: Colors.red),
                  label: Text("Hapus", style: TextStyle(color: Colors.red)),
                  onPressed: () => deleteCandidate(pair.id),
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black,
                    elevation: 4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget candidatePhotoColumn(String label, String name, String? base64Image) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: base64Image != null
              ? MemoryImage(base64Decode(base64Image))
              : null,
          child: base64Image == null
              ? const Icon(Icons.person, size: 30)
              : null,
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
