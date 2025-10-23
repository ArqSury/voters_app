import 'package:flutter/material.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              spacing: 8,
              children: [
                Image(
                  image: AssetImage('assets/images/logo/logoapp_final.png'),
                  height: 200,
                  width: 200,
                ),
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '"VOTERS ON! adalah aplikasi yang berfungsi sebagai alat pengambilan sekaligus perhitungan suara dalam Pemilihan Umum secara online dengan harapan membuat Pemilihan Umum menjadi lebih effesien dan efektif dan masih berjunjung dengan asas LUBERJURDIL"',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
