import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/database/db_helper.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<Map<String, dynamic>> results = [];
  int totalVotes = 0;
  List<bool> animateBars = [];

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final data = await DbHelper.getVotingResults();
    int sum = 0;
    for (final item in data) {
      sum += (item['votes'] ?? 0) as int;
    }
    setState(() {
      results = data;
      totalVotes = sum;
      animateBars = List.generate(data.length, (_) => false);
    });

    for (int i = 0; i < data.length; i++) {
      Future.delayed(Duration(milliseconds: 150 * (i + 1)), () {
        if (mounted) {
          setState(() {
            animateBars[i] = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Hasil Voting',
            style: TextStyle(color: AppColor.secondary),
          ),
          centerTitle: true,
          backgroundColor: AppColor.primary,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              tooltip: 'Muat Ulang',
              onPressed: _loadResult,
            ),
          ],
        ),
        body: results.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Belum ada Hasil Voting!')],
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadResult,
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final item = results[index];
                    final votes = (item['votes'] ?? 0) as int;
                    final percent = totalVotes == 0
                        ? 0.0
                        : (votes / totalVotes * 100);
                    final presName = item['presidentName'] ?? 'Presiden';
                    final viceName =
                        item['vicePresidentName'] ?? 'Wakil Presiden';
                    return builCard(
                      presName: presName,
                      viceName: viceName,
                      percent: percent,
                      votes: votes,
                      index: index,
                      context: context,
                    );
                  },
                ),
              ),
      ),
    );
  }

  Card builCard({
    required String presName,
    required String viceName,
    required num percent,
    required int votes,
    required int index,
    required BuildContext context,
  }) {
    return Card(
      color: AppColor.background,
      margin: const EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$presName & $viceName',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            buildAnimatedBar(index, context, percent),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Suara: $votes'),
                Text('${percent.toStringAsFixed(1)}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Stack buildAnimatedBar(int index, BuildContext context, num percent) {
    final maxWidth = MediaQuery.of(context).size.width - 80;
    return Stack(
      children: [
        Container(
          height: 22,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOutCubic,
          height: 22,
          width: animateBars[index] ? maxWidth * (percent / 100) : 0,
          decoration: BoxDecoration(
            color: AppColor.textButton,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
