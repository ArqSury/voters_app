import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/services/firebase_service.dart';
import 'package:voters_app/model/firebase_model/pair_with_names.dart';

class VoteResult extends StatefulWidget {
  const VoteResult({super.key});

  @override
  State<VoteResult> createState() => _VoteResultState();
}

class _VoteResultState extends State<VoteResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NewColor.cream,
      appBar: AppBar(
        backgroundColor: NewColor.redLight,
        title: const Text("Hasil Voting"),
      ),
      body: StreamBuilder<List<PairWithNames>>(
        stream: FirebaseService.instance.watchVotingResultsWithNames(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          final int totalVotes = data.fold(
            0,
            (sum, item) => sum + item.pair.votes,
          );
          if (totalVotes == 0) {
            return _noVotesWidget();
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Total Suara Masuk",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      maxY:
                          (data
                              .map((e) => e.pair.votes)
                              .reduce((a, b) => a > b ? a : b) *
                          1.2),
                      barGroups: _makeBarGroups(data),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= data.length) {
                                return const SizedBox.shrink();
                              }
                              return Text(
                                data[index].pair.number.toString(),
                                style: const TextStyle(fontSize: 14),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 800),
                    swapAnimationCurve: Curves.easeOutBack,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _noVotesWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 800),
            child: Icon(
              Icons.how_to_vote,
              size: 120,
              color: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Belum ada suara masuk",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Hasil akan tampil jika pemilih sudah memilih.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _makeBarGroups(List<PairWithNames> data) {
    return List.generate(data.length, (index) {
      final pair = data[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: pair.pair.votes.toDouble(),
            width: 26,
            borderRadius: BorderRadius.circular(6),
            color: NewColor.redDark,
          ),
        ],
      );
    });
  }
}
