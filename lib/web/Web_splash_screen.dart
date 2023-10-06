import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/web/web_login.dart';

class Web_SplashScreen extends StatefulWidget {
  const Web_SplashScreen({Key? key});

  @override
  State<Web_SplashScreen> createState() => _Web_SplashScreenState();
}

class _Web_SplashScreenState extends State<Web_SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Web_Login_Page(),
        ),
      );
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
                      "Developed By TechnoCart ",
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
