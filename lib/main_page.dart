import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:voters_app/navigation/home_page.dart';
import 'package:voters_app/navigation/notif_page.dart';
import 'package:voters_app/navigation/result_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedBar = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  static const List<Widget> _barOptions = [
    HomePage(),
    ResultPage(),
    NotifPage(),
  ];
  void _barTapped(int bar) {
    setState(() {
      _selectedBar = bar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(child: _barOptions.elementAt(_selectedBar)),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          items: [
            CurvedNavigationBarItem(
              child: Icon(Icons.home_outlined, color: Colors.white),
              label: 'Layar Utama',
              labelStyle: TextStyle(color: Colors.white),
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.bar_chart, color: Colors.white),
              label: 'Hasil Perhitungan',
              labelStyle: TextStyle(color: Colors.white),
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.notifications, color: Colors.white),
              label: 'Notifikasi',
              labelStyle: TextStyle(color: Colors.white),
            ),
          ],
          onTap: _barTapped,
          backgroundColor: Colors.white,
          color: Colors.red,
        ),
      ),
    );
  }
}
