import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/model/firebase_model/pairs_firebase.dart';
import 'package:voters_app/model/firebase_model/president_firebase.dart';
import 'package:voters_app/model/firebase_model/vice_firebase.dart';
import 'package:voters_app/services/firebase_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserVote extends StatefulWidget {
  const UserVote({super.key});

  @override
  State<UserVote> createState() => _UserVoteState();
}

class _UserVoteState extends State<UserVote> {
  PageController controller = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    checkVotingStatus();
  }

  Future<void> checkVotingStatus() async {
    final isOpen = await FirebaseService.instance.getVotingStatus();
    if (!isOpen && mounted) {
      Fluttertoast.showToast(msg: "Voting sedang ditutup.");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: NewColor.cream, body: buildLayer());
  }

  StreamBuilder<List<PairsFirebase>> buildLayer() {
    return StreamBuilder<List<PairsFirebase>>(
      stream: FirebaseService.instance.watchAllPairs(),
      builder: (ctx, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final pairs = snap.data!;
        if (pairs.isEmpty) {
          return const Center(child: Text("Belum ada pasangan calon."));
        }
        return PageView.builder(
          controller: controller,
          itemCount: pairs.length,
          itemBuilder: (ctx, i) {
            return FutureBuilder(
              future: loadPairDetail(pairs[i]),
              builder: (ctx, AsyncSnapshot<PairWithFullData> data) {
                if (!data.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return buildCard(data.data!);
              },
            );
          },
        );
      },
    );
  }

  Future<PairWithFullData> loadPairDetail(PairsFirebase pair) async {
    final presDoc = await FirebaseFirestore.instance
        .collection('presidents')
        .doc(pair.presidentId)
        .get();
    final viceDoc = await FirebaseFirestore.instance
        .collection('vice_presidents')
        .doc(pair.viceId)
        .get();
    return PairWithFullData(
      pair: pair,
      pres: PresidenFirebase.fromDoc(presDoc),
      vice: ViceFirebase.fromDoc(viceDoc),
    );
  }

  Widget buildCard(PairWithFullData data) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 15, spreadRadius: 3),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Pasangan No. ${data.pair.number}",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: NewColor.redLight,
            ),
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              profileImage(data.pres.imageBase64),
              SizedBox(width: 16),
              profileImage(data.vice.imageBase64),
            ],
          ),
          SizedBox(height: 20),
          Text(
            "${data.pres.name}\n&\n${data.vice.name}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            "${data.pair.description ?? data.pres.vision} - ${data.pres.name}",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 8),
          Text(
            "${data.pair.description ?? data.vice.vision} - ${data.vice.name}",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14),
          ),
          Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: NewColor.redLight,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            onPressed: () => confirmVote(data),
            child: const Text(
              "Pilih Pasangan Ini",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget profileImage(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return const CircleAvatar(
        radius: 55,
        backgroundImage: AssetImage(
          "assets/images/logo/logo_voterson_nobg.png",
        ),
      );
    }
    try {
      final bytes = base64Decode(base64String);
      return CircleAvatar(radius: 55, backgroundImage: MemoryImage(bytes));
    } catch (e) {
      return const CircleAvatar(
        radius: 55,
        backgroundImage: AssetImage(
          "assets/images/logo/logo_voterson_nobg.png",
        ),
      );
    }
  }

  void confirmVote(PairWithFullData data) async {
    final citizen = await FirebaseService.instance.getCurrentCitizen();
    if (citizen == null) return;
    final hasVoted = await FirebaseService.instance.hasCitizenVoted(citizen.id);
    if (hasVoted) {
      Fluttertoast.showToast(msg: "Anda sudah memilih.");
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Pilihan"),
        content: Text(
          "Apakah Anda yakin memilih:\n\n"
          "${data.pres.name} & ${data.vice.name} ?",
        ),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Pilih"),
            onPressed: () async {
              Navigator.pop(context);
              final ok = await FirebaseService.instance.castVote(
                citizenId: citizen.id,
                pairId: data.pair.id,
              );
              if (ok) {
                Fluttertoast.showToast(msg: "Terima kasih sudah memilih!");
                Navigator.pop(context);
              } else {
                Fluttertoast.showToast(msg: "Anda sudah memilih sebelumnya!");
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

class PairWithFullData {
  final PairsFirebase pair;
  final PresidenFirebase pres;
  final ViceFirebase vice;

  PairWithFullData({
    required this.pair,
    required this.pres,
    required this.vice,
  });
}
