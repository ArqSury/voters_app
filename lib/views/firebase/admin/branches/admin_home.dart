import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dashboard, size: 100, color: NewColor.redLight),
          SizedBox(height: 20),
          Text(
            "Selamat Datang di Panel Admin",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Kelola kandidat, pasangan, dan hasil voting.",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
