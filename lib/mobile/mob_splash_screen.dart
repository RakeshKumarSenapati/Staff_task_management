import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_home.dart';
import 'package:flutter_application_1/mobile/mob_login.dart';
import 'package:flutter_application_1/mobile/mob_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Mob_Splash_screen extends StatefulWidget {
  const Mob_Splash_screen({Key? key});

  @override
  State<Mob_Splash_screen> createState() => _Mob_Splash_screenState();
}

class _Mob_Splash_screenState extends State<Mob_Splash_screen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool isLoggedInAdmin = prefs.getBool('isLoggedInAdmin') ?? false;

    Timer(const Duration(seconds: 4), () {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>   Mob_Login_Page()),
      );
      if (isLoggedIn) {
        if(isLoggedInAdmin){
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeNav()), // Navigate to your home screen
        );
        }
        else{
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NavPage()), // Navigate to your home screen
        );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Mob_Login_Page()), // Navigate to your login screen
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: Colors.black,
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 150),
                  Image.asset('assets/images/Creative.gif'),
                  const SizedBox(height: 210),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Developed By TechnoCart",
                        style: TextStyle(color: Colors.white),
                      ),
                      Image.asset(
                        "assets/images/technocart.png",
                        height: 30,
                        width: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
  