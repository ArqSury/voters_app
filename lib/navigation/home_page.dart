import 'package:flutter/material.dart';
import 'package:voters_app/branches/about_app.dart';
import 'package:voters_app/branches/home_screen.dart';
import 'package:voters_app/branches/profil_page.dart';
import 'package:voters_app/branches/user_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedDrawer = 0;

  static const List<Widget> _drawerOptions = [
    HomeScreen(),
    UserPage(),
    ProfilPage(),
    AboutApp(),
  ];
  void drawTapped(int draw) {
    setState(() {
      _selectedDrawer = draw;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Layar Utama'), backgroundColor: Colors.red),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/logo/logo_voterson_nobg.png',
                ),
              ),
              title: Text('Nama'),
              subtitle: Text('Provinsi'),
            ),
            Divider(),
            ListTile(
              onTap: () {
                drawTapped(0);
              },
              leading: Icon(Icons.home),
              title: Text('Layar Utama'),
            ),
            ListTile(
              onTap: () {
                drawTapped(1);
              },
              leading: Icon(Icons.person),
              title: Text('Profil Peserta'),
            ),
            ListTile(
              onTap: () {
                drawTapped(2);
              },
              leading: Icon(Icons.book),
              title: Text('Biodata Calon'),
            ),
            ListTile(
              onTap: () {
                drawTapped(3);
              },
              leading: Icon(Icons.question_mark),
              title: Text('Tentang Aplikasi'),
            ),
          ],
        ),
      ),
      body: _drawerOptions[_selectedDrawer],
    );
  }
}
