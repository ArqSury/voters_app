import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/model/firebase_model/pairs_firebase.dart';
import 'package:voters_app/model/firebase_model/president_firebase.dart';
import 'package:voters_app/model/firebase_model/vice_firebase.dart';
import 'package:voters_app/services/firebase_service.dart';

class CandidateData extends StatefulWidget {
  const CandidateData({super.key});

  @override
  State<CandidateData> createState() => _CandidateDataState();
}

class _CandidateDataState extends State<CandidateData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NewColor.cream,
      appBar: AppBar(
        backgroundColor: NewColor.redLight,
        centerTitle: true,
        title: const Text(
          "Data Pasangan Calon",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<List<PairsFirebase>>(
        stream: FirebaseService.instance.watchAllPairs(),
        builder: (ctx, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final pairs = snap.data!;
          if (pairs.isEmpty) {
            return const Center(child: Text("Belum ada pasangan calon."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pairs.length,
            itemBuilder: (_, i) {
              return FutureBuilder(
                future: loadFullPair(pairs[i]),
                builder: (ctx, AsyncSnapshot<PairFullData> data) {
                  if (!data.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return buildCandidateCard(data.data!);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<PairFullData> loadFullPair(PairsFirebase pair) async {
    final pres = await FirebaseFirestore.instance
        .collection('presidents')
        .doc(pair.presidentId)
        .get();

    final vice = await FirebaseFirestore.instance
        .collection('vice_presidents')
        .doc(pair.viceId)
        .get();

    return PairFullData(
      pair: pair,
      pres: PresidenFirebase.fromDoc(pres),
      vice: ViceFirebase.fromDoc(vice),
    );
  }

  Widget buildCandidateCard(PairFullData d) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 12, spreadRadius: 2),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 18),
        childrenPadding: const EdgeInsets.all(16),
        title: Text(
          "Pasangan No. ${d.pair.number}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: NewColor.redLight,
          ),
        ),

        subtitle: Text(
          "${d.pres.name} & ${d.vice.name}",
          style: const TextStyle(fontSize: 16),
        ),

        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            circlePhoto(d.pres.imagePath),
            const SizedBox(width: 6),
            circlePhoto(d.vice.imagePath),
          ],
        ),

        children: [
          buildDetailSection("Presiden", d.pres),
          const SizedBox(height: 20),
          buildDetailSection("Wakil Presiden", d.vice),
          const SizedBox(height: 10),

          if (d.pair.description != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [label("Deskripsi"), text(d.pair.description!)],
            ),
        ],
      ),
    );
  }

  Widget circlePhoto(String? path) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: path != null
          ? NetworkImage(path)
          : const AssetImage("assets/images/logo/logo_voterson_nobg.png")
                as ImageProvider,
    );
  }

  Widget buildDetailSection(String title, dynamic model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title: ${model.name}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),

        rowText("Umur", "${model.age} Tahun"),
        rowText(
          "Jenis Kelamin",
          model.gender == "L" ? "Laki-Laki" : "Perempuan",
        ),
        rowText("Pendidikan", model.education),

        if (model.experience != null && model.experience!.isNotEmpty)
          rowText("Pengalaman", model.experience!),

        if (model.achivement != null && model.achivement!.isNotEmpty)
          rowText("Prestasi", model.achivement!),

        const SizedBox(height: 10),
        label("Visi"),
        text(model.vision),

        const SizedBox(height: 10),
        label("Misi"),
        text(model.mission),
      ],
    );
  }

  Widget rowText(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$k :", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }

  Widget label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      t,
      style: TextStyle(
        fontSize: 16,
        color: NewColor.redLight,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget text(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(t, style: const TextStyle(fontSize: 14)),
  );
}

class PairFullData {
  final PairsFirebase pair;
  final PresidenFirebase pres;
  final ViceFirebase vice;

  PairFullData({required this.pair, required this.pres, required this.vice});
}
