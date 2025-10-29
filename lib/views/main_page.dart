import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/navigation/about_screen.dart';
import 'package:voters_app/navigation/home_screen.dart';
import 'package:voters_app/navigation/result_screen.dart';
import 'package:voters_app/navigation/user_profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedBar = 0;

  static const List<Widget> _navOptions = [
    HomeScreen(),
    UserProfile(),
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Rumah'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Hasil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.question_mark),
              label: 'Tentang',
            ),
          ],
          currentIndex: _selectedBar,
          selectedItemColor: AppColor.primary,
          backgroundColor: AppColor.button,
          onTap: _onBarTapped,
        ),
        body: Center(child: _navOptions.elementAt(_selectedBar)),
      ),
    );
  }
}
