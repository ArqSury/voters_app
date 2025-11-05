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
    }

    await DbHelper.castVote(widget.citizenId, pairId);
    Fluttertoast.showToast(msg: 'Vote Anda berhasil disimpan!');
    setState(() {
      hasVoted = true;
    });
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
        child: candidatePairs.isEmpty
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
      child: ListTile(
        leading: Row(
          children: [
            Image(image: NetworkImage(pres.imageUrl ?? '')),
            Image(image: NetworkImage(vice.imageUrl ?? '')),
          ],
        ),
        title: Text(
          '${pres.name} & ${vice.name}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: BuildButton(
          text: hasVoted ? 'Sudah memilih' : 'Pilih',
          width: 60,
          height: 60,
          onPressed: hasVoted ? null : () => _voteForCandidate(pair['id']),
          backgroundColor: hasVoted ? Colors.grey : AppColor.primary,
        ),
      ),
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
