import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/database/db_helper.dart';
import 'package:voters_app/function/build_button.dart';
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
            : Stack(
                children: [
                  buildBackground(),
                  SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            alignment: AlignmentDirectional.centerStart,
                            decoration: BoxDecoration(
                              color: AppColor.button,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              boxShadow: [BoxShadow(blurRadius: 8)],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Halo, ${dataUser?.name ?? ''}!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserProfile(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Lihat Profil',
                                    style: TextStyle(color: AppColor.secondary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 240,
                            width: double.infinity,
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColor.button,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              boxShadow: [BoxShadow(blurRadius: 8)],
                            ),
                            alignment: AlignmentDirectional.topCenter,
                            child: Column(
                              spacing: 8,
                              children: [
                                Text(
                                  'Biodata Calon',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    spacing: 12,
                                    children: [
                                      BuildButton(
                                        text: 'Pasangan\nCalon\n1',
                                        width: 120,
                                        height: 150,
                                        onPressed: () {},
                                      ),
                                      BuildButton(
                                        text: 'Pasangan\nCalon\n2',
                                        width: 120,
                                        height: 150,
                                        onPressed: () {},
                                      ),
                                      BuildButton(
                                        text: 'Pasangan\nCalon\n3',
                                        width: 120,
                                        height: 150,
                                        onPressed: () {},
                                      ),
                                      BuildButton(
                                        text: 'Pasangan\nCalon\n4',
                                        width: 120,
                                        height: 150,
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: AppColor.background,
    );
  }
}
