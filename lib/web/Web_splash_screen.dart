import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_home.dart';

import 'package:flutter_application_1/web/web_login.dart';
import 'package:flutter_application_1/web/web_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Web_SplashScreen extends StatefulWidget {
  const Web_SplashScreen({Key? key});

  @override
  State<Web_SplashScreen> createState() => _Web_SplashScreenState();
}

class _Web_SplashScreenState extends State<Web_SplashScreen> {
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
                  Web_Login_Page()), // Navigate to your login screen
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 150),
                Image.asset('assets/images/Creative.gif'),
                const SizedBox(height: 50), // Adjust spacing for larger screens
                // const Text(
                //   "Welcome to Our Web Application",
                //   style: TextStyle(fontSize: 24, color: Colors.white),
                // ),
                // const SizedBox(height: 50), // Adjust spacing for larger screens
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Developed By TechnoCrat ",
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
        ),
      ),
    );
  }
}
