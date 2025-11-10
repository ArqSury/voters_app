import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/database/db_helper.dart';
import 'package:voters_app/model/citizen_model.dart';
import 'package:voters_app/navigation/user_profile.dart';
import 'package:voters_app/navigation/voting_page.dart';
import 'package:voters_app/share_preference/preference_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CitizenModel? dataUser;
  bool? hasVoted;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    int id = await PreferenceHandler.getId();
    final data = await DbHelper.getCitizenById(id);
    final voted = await DbHelper.hasCitizenVoted(id);
    setState(() {
      dataUser = data;
      hasVoted = voted;
    });
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

  Container buildUserVote() {
    final voted = hasVoted ?? false;
    return Container(
      height: 560,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: decorationContainer(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Text(
            'Gunakan\n Hak Pilihmu!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 36,
              fontFamily: 'Times New Roman',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: voted
                ? null
                : () {
                    if (dataUser != null && dataUser!.id != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VotingPage(citizenId: dataUser!.id!),
                        ),
                      );
                    }
                  },
            child: Text(
              voted ? 'Sudah Memilih' : 'Vote Sekarang',
              style: TextStyle(
                color: voted ? AppColor.primary : AppColor.textButton,
                fontSize: 16,
              ),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              IconButton(
                tooltip: 'Halaman Profil',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfile()),
                  );
                },
                icon: Icon(Icons.person, color: AppColor.textButton),
              ),
              Text(
                'Halo, ${dataUser?.name ?? ''}!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
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
          colors: [AppColor.primary, AppColor.secondary],
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
        ),
      ),
    );
  }
}
