import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/database/db_helper.dart';
import 'package:voters_app/function/build_button.dart';
import 'package:voters_app/model/president_model.dart';
import 'package:voters_app/model/vice_president_model.dart';

class VotingPage extends StatefulWidget {
  final int citizenId;
  const VotingPage({super.key, required this.citizenId});

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  List<Map<String, dynamic>> candidatePairs = [];
  bool hasVoted = false;

  @override
  void initState() {
    super.initState();
    _loadVotingData();
  }

  Future<void> _loadVotingData() async {
    final voted = await DbHelper.hasCitizenVoted(widget.citizenId);
    final pairs = await DbHelper.getAllPairs();
    setState(() {
      hasVoted = voted;
      candidatePairs = pairs;
    });
  }

  Future<void> _voteForCandidate(int pairId) async {
    if (hasVoted) {
      Fluttertoast.showToast(msg: 'Anda sudah memberikan suara');
      return;
    }

    await DbHelper.castVote(widget.citizenId, pairId);
    Fluttertoast.showToast(msg: 'Vote Anda berhasil disimpan!');
    setState(() {
      hasVoted = true;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Stack(children: [buildBackground(), buildLayer()])),
    );
  }

  Padding buildLayer() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: hasVoted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Terima kasih\n'
                    'Sudah Menggunakan\n'
                    'Hak Pilihmu',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : candidatePairs.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Belum ada pasangan calon')],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: candidatePairs.length,
                itemBuilder: (context, index) {
                  final pair = candidatePairs[index];
                  final pres = PresidentModel.fromMap(pair['president']);
                  final vice = VicePresidentModel.fromMap(
                    pair['vice_president'],
                  );
                  return buildCard(pres, vice, pair);
                },
              ),
      ),
    );
  }

  Card buildCard(
    PresidentModel pres,
    VicePresidentModel vice,
    Map<String, dynamic> pair,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              '${pres.name} & ${vice.name}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildPresidentImage(pres),
                buildVicePresidentImage(vice),
              ],
            ),
            SizedBox(height: 12),
            BuildButton(
              text: hasVoted ? 'Sudah memilih' : 'Pilih',
              color: Colors.black,
              width: 120,
              height: 60,
              onPressed: hasVoted
                  ? null
                  : () => _voteForCandidate(pair['id'] ?? pair['pairId']),
              backgroundColor: hasVoted ? Colors.grey : AppColor.primary,
            ),
          ],
        ),
      ),
    );
  }

  Image buildVicePresidentImage(VicePresidentModel vice) {
    return Image(
      image: (vice.imageUrl != null && vice.imageUrl!.isNotEmpty)
          ? NetworkImage(vice.imageUrl!)
          : AssetImage('assets/images/logo/profil_foto.jpg') as ImageProvider,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }

  Image buildPresidentImage(PresidentModel pres) {
    return Image(
      image: (pres.imageUrl != null && pres.imageUrl!.isNotEmpty)
          ? NetworkImage(pres.imageUrl!)
          : AssetImage('assets/images/logo/profil_foto.jpg') as ImageProvider,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: AppColor.background,
    );
  }
}
