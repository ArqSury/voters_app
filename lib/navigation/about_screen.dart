import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 12,
                children: [
                  Image(
                    image: AssetImage('assets/images/logo/logoapp_final.png'),
                    height: 300,
                  ),
                  Text(
                    '"Voters On! adalah aplikasi pemilu untuk mengambil dan menghitung suara pilihan rakyat Indonesia yang menjunjung asas LUBERJURDIL. Aplikasi ini memiliki beberapa fitur seperti profil biodata calon-calon anggota pemerintahan yang akan dipilih. Selain itu juga aplikasi ini memiliki fitur Live Count Vote dimana akan ada perhitungan suara secara langsung dan seksama yang bisa dilihat oleh seluruh rakyat Indonesia sehingga diharapkan pemilu berjalan adil serta efektif dan efesien"',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 60),
                  Text(
                    'Creator',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  Image(
                    image: AssetImage('assets/images/logo/smile.png'),
                    height: 200,
                  ),
                  Text('ARIQ SURYA WARDHANA'),
                  Text('MOBILE PROGRAMMING'),
                  Text('BATCH 4'),
                  Text('PPKD JAKARTA PUSAT'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
