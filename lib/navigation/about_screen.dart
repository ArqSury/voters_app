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
                    '"Voters ON! adalah aplikasi e-voting yang dirancang untuk memudahkan proses pemilihan secara digital. Dengan tampilan sederhana dan fitur yang mudah digunakan, pengguna dapat memberikan suara mereka secara aman, cepat, dan transparan."',
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
