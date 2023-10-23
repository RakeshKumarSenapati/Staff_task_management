import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/mobile/mob_add_task.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../consts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mob_task_mgmt.dart';


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
        prefs.setString('userID', user.text);
        prefs.setString('password', pass.text);
        setState(() {
          // Navigate to the HomePage on successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  Mob_Add_Task()),
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          height: double.maxFinite,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [g1, g2]),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(size.height * 0.030),
              child: OverflowBar(
                overflowAlignment: OverflowBarAlignment.center,
                overflowSpacing: size.height * 0.014,
                children: [
                  Container(
                    // width: 280,
                    // height: ,
                    
                    // padding: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(size.height * 0.065),
                    decoration: const BoxDecoration(),
                    child: Image.asset(image2),
                  ),
                  const Text(
                    "Welcom Back !",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    "Please , Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: size.height * 0.024),
                  Form(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: user,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: kInputColor),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 25.0),
                          filled: true,
                          hintText: "User Name",
                          prefixIcon: IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(userIcon)),
                          fillColor: kWhiteColor,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(36),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: pass,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: kInputColor),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 25.0),
                          filled: true,
                          hintText: "Password",
                          prefixIcon: IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(keyIcon)),
                          fillColor: kWhiteColor,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(36),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the password';
                          }
                          return null;
                        },
                      ),
                    ],
                  )),
                  SizedBox(
                            height: size.height * 0.014,
                          ),
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: size.height * 0.080,
                        decoration: BoxDecoration(
                          color: kButtonColor,
                          borderRadius: BorderRadius.circular(37),
                        ),
                      
                        child: const Text(
                        "Login",
                        style: TextStyle(
                          color: kWhiteColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    onPressed: () {
                      // insertrecord();

                      _login();

                      // ccc
                    // }),
                        
                      }),
                  SizedBox(
                    height: size.height * 0.014,
                  ),
                  SvgPicture.asset("assets/icons/deisgn.svg"),
                  Container(
                    padding: EdgeInsets.zero,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: size.height * 0.080,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 45,
                            spreadRadius: 0,
                            color: Color.fromRGBO(120, 37, 139, 0.25),
                            offset: Offset(0, 25),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromRGBO(225, 225, 225, 0.28),
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "In case you can face any problem then contact Our Suppert Team Member",
                            style: TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ),
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
