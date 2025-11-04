import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';

class CandidateScreen extends StatefulWidget {
  const CandidateScreen({super.key});

  @override
  State<CandidateScreen> createState() => _CandidateScreenState();
}

class _CandidateScreenState extends State<CandidateScreen> {
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
            Text(
              'Pilih Pasangan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(color: Colors.black, indent: 20, endIndent: 20),
            SizedBox(height: 10),
          ],
        ),
      ),
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
