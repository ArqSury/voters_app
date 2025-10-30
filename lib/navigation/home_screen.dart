import 'package:flutter/material.dart';
import 'package:voters_app/database/db_helper.dart';
import 'package:voters_app/share_preference/preference_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  getUser() async {
    int id = await PreferenceHandler.getId();
    DbHelper.getCitizenById(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child: Column(children: [Text('Home Screen')])),
      ),
    );
  }
}
