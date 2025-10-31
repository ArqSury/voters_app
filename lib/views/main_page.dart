import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/navigation/about_screen.dart';
import 'package:voters_app/navigation/candidate_screen.dart';
import 'package:voters_app/navigation/home_screen.dart';
import 'package:voters_app/navigation/result_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedBar = 0;

  static const List<Widget> _navOptions = [
    HomeScreen(),
    CandidateScreen(),
    ResultScreen(),
    AboutScreen(),
  ];
  void _onBarTapped(int bar) {
    setState(() {
      _selectedBar = bar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              backgroundColor: AppColor.primary,
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              backgroundColor: AppColor.primary,
              label: 'Kandidat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              backgroundColor: AppColor.primary,
              label: 'Hasil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.question_mark),
              backgroundColor: AppColor.primary,
              label: 'Tentang',
            ),
          ],
          currentIndex: _selectedBar,
          selectedItemColor: AppColor.background,
          onTap: _onBarTapped,
        ),
        body: Center(child: _navOptions.elementAt(_selectedBar)),
      ),
    );
  }
}
