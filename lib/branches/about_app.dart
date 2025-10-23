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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              spacing: 8,
              children: [
                Image(
                  image: AssetImage("assets/images/logo/logoapp_final.png"),
                  height: 240,
                  width: 300,
                ),
                Text('"VOTERS ON!'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
