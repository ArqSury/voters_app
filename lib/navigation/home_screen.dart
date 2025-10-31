import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/database/db_helper.dart';

import 'package:voters_app/model/citizen_model.dart';
import 'package:voters_app/navigation/user_profile.dart';
import 'package:voters_app/share_preference/preference_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CitizenModel? dataUser;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    int id = await PreferenceHandler.getId();
    final data = await DbHelper.getCitizenById(id);
    dataUser = data;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: dataUser == null
            ? Center(child: CircularProgressIndicator())
            : Stack(children: [buildBackground(), buildLayer(context)]),
      ),
    );
  }

  SingleChildScrollView buildLayer(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildUserProfile(context),
              SizedBox(height: 10),
              buildUserVote(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildUserVote({bool isVoted = false}) {
    return Container(
      height: 140,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: decorationContainer(),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            'Gunakan Hak Pilihmu!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'Times New Roman',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              setState(() {});
            },
            child: isVoted
                ? Text(
                    'Voted',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  )
                : Text(
                    'Vote',
                    style: TextStyle(color: AppColor.textButton, fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }

  Container buildUserProfile(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      alignment: AlignmentDirectional.centerStart,
      decoration: decorationContainer(),
      child: Row(
        children: [
          Text(
            'Halo, ${dataUser?.name ?? ''}!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile()),
              );
            },
            child: Text(
              'Lihat Profil',
              style: TextStyle(color: AppColor.secondary),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration decorationContainer() {
    return BoxDecoration(
      color: AppColor.backup,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      boxShadow: [BoxShadow(blurRadius: 8)],
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.background, AppColor.primary, AppColor.secondary],
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
        ),
      ),
    );
  }
}
