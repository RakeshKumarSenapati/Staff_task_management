import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/mobile/mob_Profile.dart';
import 'package:flutter_application_1/mobile/mob_add_task.dart';
import 'package:flutter_application_1/mobile/mob_contact_prev.dart';
import 'package:flutter_application_1/mobile/mob_login.dart';
import 'mob_details.dart';

class Mob_Splash_screen extends StatefulWidget {
  const Mob_Splash_screen({Key? key});

  @override
  State<Mob_Splash_screen> createState() => _Mob_Splash_screenState();
}

class _Mob_Splash_screenState extends State<Mob_Splash_screen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  ContactPrev(title: 'Contact',)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: Colors.black,
            width: constraints.maxWidth, // Set width to screen's maximum width
            height: constraints.maxHeight, // Set height to screen's maximum height
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
          );
        },
      ),
    );
  }
}
