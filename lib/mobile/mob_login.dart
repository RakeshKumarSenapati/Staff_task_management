import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/admin_home.dart';
import 'package:flutter_application_1/mobile/mob_navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class Mob_Login_Page extends StatefulWidget {
  const Mob_Login_Page({super.key});

  @override
  State<Mob_Login_Page> createState() => _Mob_Login_PageState();
}

class _Mob_Login_PageState extends State<Mob_Login_Page> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('https://creativecollege.in/Flutter/Login.php'),
      body: {
        'user': user.text,
        'pass': pass.text,
      },
    );

    if (response.statusCode == 200) {
      if (response.body == 'Success') {
        Fluttertoast.showToast(
          msg: 'Login Successful',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true); // Mark the user as logged in
        prefs.setString('userID', user.text); // Save user ID
        prefs.setString('password', pass.text); // Save password

        setState(() {
          // Navigate to the HomePage on successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NavPage()),
            result: MaterialPageRoute(builder: (context) => NavPage()),
          );
        });
      } else if (response.body == 'Admin') {
        Fluttertoast.showToast(
          msg: 'Login Successful',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true); // Mark the user as logged in
        prefs.setBool('isLoggedInAdmin', true); // Mark the user as logged in
        prefs.setString('userID', user.text); // Save user ID
        prefs.setString('password', pass.text); // Save password

        setState(() {
          // Navigate to the HomePage on successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeNav()),
            result: MaterialPageRoute(builder: (context) => HomeNav()),
          );
        });
      } else {
        Fluttertoast.showToast(
          msg: 'Login Failed Enter Correct Details',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        // Handle unsuccessful login
        print("Login failed");
      }
    } else {
      // Handle other HTTP status codes
      print("Error: ${response.statusCode}");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeInUp(
                            duration: Duration(seconds: 1),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-1.png'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                            duration: Duration(milliseconds: 1200),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-2.png'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                            duration: Duration(milliseconds: 1300),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/clock.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeInUp(
                            duration: Duration(milliseconds: 1600),
                            child: Container(
                              margin: EdgeInsets.only(top: 250),
                              child: Center(
                                  child: Column(
                                children: [
                                  
                                  Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 20,),
                                  Image.asset(
                                    'assets/images/ctclogo.png',
                                    width:
                                        125, // Set the width as needed for larger screens
                                  ),

                                ],
                              )),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeInUp(
                          duration: Duration(milliseconds: 1800),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Color.fromRGBO(143, 148, 251, 1)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color.fromRGBO(
                                                  143, 148, 251, 1)))),
                                  child: TextField(
                                    controller: user,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Username",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[700])),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: pass,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[700])),
                                  ),
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1900),
                        child: InkWell(
                          onTap: () {
                            _login();
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(143, 148, 251, 1),
                                  Color.fromRGBO(143, 148, 251, .6),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 2000),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                            "Designed By Technocrat",
                            style: TextStyle(
                                color: Color.fromRGBO(143, 148, 251, 1)),
                          ),
                          SizedBox(width: 2,),
                           Image.asset(
                                    'assets/images/technocart.png',
                                    width:
                                        25,
                                         // Set the width as needed for larger screens
                                  ),
                            ],
                          )
                          ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
