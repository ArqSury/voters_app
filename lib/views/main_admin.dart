import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/views/_admin/admin_list.dart';
import 'package:voters_app/views/_admin/admin_login_page.dart';
import 'package:voters_app/views/_admin/admin_page.dart';

class MainAdmin extends StatefulWidget {
  const MainAdmin({super.key});

  @override
  State<MainAdmin> createState() => _MainAdminState();
}

class _MainAdminState extends State<MainAdmin> {
  int _selectedDrawer = 0;
  static const List<Widget> _widgetOption = [AdminPage(), AdminList()];
  void onTapDrawer(int index) {
    setState(() {
      _selectedDrawer = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin', style: TextStyle(color: AppColor.secondary)),
          centerTitle: true,
          backgroundColor: AppColor.primary,
        ),
        drawer: Drawer(
          backgroundColor: AppColor.secondary,
          child: ListView(
            children: [
              ListTile(
                onTap: () {
                  onTapDrawer(0);
                },
                leading: Icon(Icons.person),
                title: Text('Pendaftaran Calon'),
              ),
              ListTile(
                onTap: () {
                  onTapDrawer(1);
                },
                leading: Icon(Icons.book),
                title: Text('Daftar Calon'),
              ),
              Divider(),
              ListTile(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AdminLoginPage()),
                    (route) => false,
                  );
                },
                leading: Icon(Icons.logout),
                title: Text('Keluar'),
              ),
            ],
          ),
        ),
        body: _widgetOption[_selectedDrawer],
      ),
    );
  }
}
