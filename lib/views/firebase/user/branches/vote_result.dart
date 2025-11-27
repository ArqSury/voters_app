import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/model/firebase_model/pair_with_names.dart';
import 'package:voters_app/services/firebase_service.dart';

class VoteResult extends StatefulWidget {
  const VoteResult({super.key});

  @override
  State<VoteResult> createState() => _VoteResultState();
}

class _VoteResultState extends State<VoteResult> {
  List<bool> animateBars = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NewColor.cream,
      appBar: AppBar(
        backgroundColor: NewColor.redLight,
        title: const Text(
          "Hasil Voting",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<PairWithNames>>(
        stream: FirebaseService.instance.watchVotingResultsWithNames(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snap.data!;
          if (data.isEmpty) {
            return const Center(child: Text("Belum ada hasil voting."));
          }
          final totalVotes = data.fold(0, (sum, item) => sum + item.pair.votes);
          if (totalVotes == 0) {
            return _noVotes();
          }
          if (animateBars.length != data.length) {
            animateBars = List.generate(data.length, (_) => false);
            _runBarAnimations();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (_, i) {
              final item = data[i];
              final votes = item.pair.votes;
              final percent = totalVotes == 0.0
                  ? 0.0
                  : (votes / totalVotes * 100);
              return _resultCard(
                index: i,
                pres: item.presidentName,
                vice: item.viceName,
                votes: votes,
                percent: percent,
                context: context,
              );
            },
          );
        },
      ),
    );
  }

  void _runBarAnimations() async {
    for (int i = 0; i < animateBars.length; i++) {
      await Future.delayed(Duration(milliseconds: 180));
      if (mounted) {
        setState(() => animateBars[i] = true);
      }
    }
  }

  Widget _resultCard({
    required int index,
    required String pres,
    required String vice,
    required int votes,
    required double percent,
    required BuildContext context,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$pres & $vice",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            _animatedBar(index, percent),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Suara: $votes",
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
                Text(
                  "${percent.toStringAsFixed(1)}%",
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedBar(int index, double percent) {
    final maxW = MediaQuery.of(context).size.width - 80;
    return Stack(
      children: [
        Container(
          height: 22,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOutCubic,
          height: 22,
          width: animateBars[index] ? maxW * (percent / 100) : 0,
          decoration: BoxDecoration(
            color: NewColor.redLight,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Widget _noVotes() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.how_to_vote, size: 120, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          const Text(
            "Belum ada suara masuk",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text("Tunggu hingga pemilih memberikan suara."),
        ],
      ),
    );
  }
}
