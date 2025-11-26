import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/services/firebase_service.dart';
import 'package:voters_app/views/firebase/admin/branches/add_candidates.dart';
import 'package:voters_app/views/firebase/admin/branches/manage_voting.dart';
import 'package:voters_app/views/firebase/admin/branches/admin_home.dart';
import 'package:voters_app/views/firebase/admin/branches/list_candidates.dart';
import 'package:voters_app/views/firebase/admin/branches/register_admin.dart';
import 'package:voters_app/views/firebase/admin/login_admin.dart';

class AdminCenter extends StatefulWidget {
  const AdminCenter({super.key, required this.isSuperAdmin});
  final bool isSuperAdmin;

  @override
  State<AdminCenter> createState() => _AdminCenterState();
}

class _AdminCenterState extends State<AdminCenter> {
  int pageIndex = 0;

  static const List<Widget> pages = [
    AdminHome(),
    AddCandidates(),
    ManageVoting(),
    ListCandidates(),
    RegisterAdmin(),
  ];

  void onTapDrawer(int index) {
    setState(() {
      pageIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NewColor.cream,
      appBar: AppBar(
        backgroundColor: NewColor.redLight,
        title: Text('Admin Panel', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            buildTile(icon: Icons.admin_panel_settings, title: 'Admin'),
            Divider(),
            buildTile(
              icon: Icons.home,
              title: 'Dashboard',
              onTap: () {
                onTapDrawer(0);
              },
            ),
            buildTile(
              icon: Icons.person,
              title: 'Register Kandidat',
              onTap: () {
                onTapDrawer(1);
              },
            ),
            buildTile(
              icon: Icons.timelapse,
              title: 'Manage Voting',
              onTap: () {
                onTapDrawer(2);
              },
            ),
            buildTile(
              icon: Icons.list,
              title: 'Daftar Kandidat',
              onTap: () {
                onTapDrawer(3);
              },
            ),
            if (widget.isSuperAdmin)
              buildTile(
                icon: Icons.app_registration,
                title: 'Register Admin',
                onTap: () {
                  onTapDrawer(4);
                },
              ),
            Divider(),
            buildTile(
              icon: Icons.logout,
              title: 'Log Out',
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginAdmin()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: pages[pageIndex],
    );
  }

  ListTile buildTile({IconData? icon, String? title, void Function()? onTap}) {
    return ListTile(leading: Icon(icon), title: Text('$title'), onTap: onTap);
  }

  Future<void> logout() async {
    await FirebaseService.instance.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginAdmin()),
      (route) => false,
    );
  }
}
