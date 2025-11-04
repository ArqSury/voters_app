import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/database/db_helper.dart';
import 'package:voters_app/model/president_model.dart';
import 'package:voters_app/model/vice_president_model.dart';

class CandidateScreen extends StatefulWidget {
  const CandidateScreen({super.key});

  @override
  State<CandidateScreen> createState() => _CandidateScreenState();
}

class _CandidateScreenState extends State<CandidateScreen> {
  List<Map<String, dynamic>> candidatePairs = [];

  @override
  void initState() {
    super.initState();
    _loadCandidates();
  }

  Future<void> _loadCandidates() async {
    final pairs = await DbHelper.getAllPairs();
    setState(() {
      candidatePairs = pairs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: AppColor.primary),
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [buildBackground(), buildLayer()],
        ),
      ),
    );
  }

  Center buildLayer() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(height: 10),
            ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: candidatePairs.length,
              itemBuilder: (context, index) {
                final pair = candidatePairs[index];
                final president = PresidentModel.fromMap(pair['president']);
                final vicePresident = VicePresidentModel.fromMap(
                  pair['vice_president'],
                );
                return buildCard(index, president, vicePresident);
              },
            ),
          ],
        ),
      ),
    );
  }

  Card buildCard(
    int index,
    PresidentModel president,
    VicePresidentModel vicePresident,
  ) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pasangan Calon ${candidatePairs[index]}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: buildPresidentProfile(president)),
                SizedBox(width: 10),
                Expanded(child: buildVicePresidentProfile(vicePresident)),
              ],
            ),
            Divider(height: 20, color: Colors.black),
            _buildVisionMission(president, vicePresident),
          ],
        ),
      ),
    );
  }

  Column buildVicePresidentProfile(VicePresidentModel vicePresident) {
    return Column(
      children: [
        CircleAvatar(radius: 40),
        SizedBox(height: 8),
        Text('Nama', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(vicePresident.name, style: const TextStyle(fontSize: 15)),
        const SizedBox(height: 8),
        Text(
          'Edukasi: ${vicePresident.education}',
          textAlign: TextAlign.center,
        ),
        Text(
          'Pengalaman: ${vicePresident.experience}',
          textAlign: TextAlign.center,
        ),
        Text(
          'Pencapaian: ${vicePresident.achivement}',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Column buildPresidentProfile(PresidentModel president) {
    return Column(
      children: [
        CircleAvatar(radius: 40),
        const SizedBox(height: 8),
        Text('Nama', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(president.name, style: const TextStyle(fontSize: 15)),
        const SizedBox(height: 8),
        Text('Edukasi: ${president.education}', textAlign: TextAlign.center),
        Text(
          'Pengalaman: ${president.experience}',
          textAlign: TextAlign.center,
        ),
        Text(
          'Pencapaian: ${president.achivement}',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Column _buildVisionMission(PresidentModel pres, VicePresidentModel vp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Visi & Misi',
          style: TextStyle(
            color: AppColor.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text('Visi Pasangan: ${pres.vision}'),
        Text('Misi Pasangan: ${vp.mission}'),
      ],
    );
  }

  BoxDecoration decorationContainer() {
    return BoxDecoration(
      color: AppColor.backup,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      boxShadow: [BoxShadow(blurRadius: 8)],
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.backup,
            AppColor.background,
            AppColor.primary,
            AppColor.secondary,
          ],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
      ),
    );
  }
}
