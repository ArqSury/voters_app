import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/views/firebase/user/branches/candidate_data.dart';
import 'package:voters_app/views/firebase/user/branches/user_data.dart';
import 'package:voters_app/views/firebase/user/branches/user_home.dart';
import 'package:voters_app/views/firebase/user/branches/vote_result.dart';

class UserCenter extends StatefulWidget {
  const UserCenter({super.key});

  @override
  State<UserCenter> createState() => _UserCenterState();
}

class _UserCenterState extends State<UserCenter> {
  int _selectedBar = 0;

  static const List<Widget> _navOptions = [
    UserHome(),
    CandidateData(),
    VoteResult(),
    UserData(),
  ];

  void _onBarTapped(int bar) {
    setState(() {
      _selectedBar = bar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
            backgroundColor: NewColor.redLight,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Kandidat',
            backgroundColor: NewColor.redLight,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Hasil',
            backgroundColor: NewColor.redLight,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Anda',
            backgroundColor: NewColor.redLight,
          ),
        ],
        type: BottomNavigationBarType.shifting,
        elevation: 8,
        currentIndex: _selectedBar,
        selectedItemColor: Colors.white,
        unselectedItemColor: NewColor.gold,
        onTap: _onBarTapped,
      ),
      body: Center(child: _navOptions.elementAt(_selectedBar)),
    );
  }
}
