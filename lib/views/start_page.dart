import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/views/firebase/admin/login_admin.dart';
import 'package:voters_app/views/firebase/user/login_user.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    isLoginFunction();
  }

  isLoginFunction() async {
    Future.delayed(Duration(seconds: 3)).then((value) async {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginUser()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginAdmin()),
          (route) => false,
        );
      },
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColor.primary, AppColor.secondary],
                        begin: AlignmentDirectional.topCenter,
                        end: AlignmentDirectional.bottomCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(
                            'assets/images/logo/logo_voterson_nobg2.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
