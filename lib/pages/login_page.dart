
// import 'dart:js_interop';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/dashboard.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'consts.dart';
import 'package:http/http.dart' as http;

class Login_Page extends StatefulWidget {
  const Login_Page({super.key});

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {

  TextEditingController user =  TextEditingController();
  TextEditingController pass =  TextEditingController();

  Future<void> insertrecord() async{
    if(user.text != "" || pass.text != ""){
      try{
        String uri = "https://creativecollege.in/Flutter%20php/insert.php";
        var res = await http.post(Uri.parse(uri),body: {
          "user":user.text,
          "pass":pass.text
        });

        var response = jsonDecode(res.body);
        
        if(response["success"] == "true"){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
        }
        else{
          log("Record insert Failed");
        }
      }
      catch(e){
        print(e);
      }

    }
    else{
      print("fill all field");
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
                  padding: EdgeInsets.all(size.height * 0.065),
                  decoration: const BoxDecoration(),
                  child: Image.asset(image2),
                ),
                Text(
                  "Welcom Back !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: kWhiteColor.withOpacity(0.7),
                  ),
                ),
                const Text(
                  "Please , Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                    color: kWhiteColor,
                  ),
                ),
                SizedBox(height: size.height * 0.024),
                Form(
                  
                  child: Column(
                    children: [
                    TextFormField(

                    controller: user,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: kInputColor),
                    decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 25.0),
                    filled: true,
                    hintText: "User Name",
                    prefixIcon: IconButton(
                        onPressed: () {}, icon: SvgPicture.asset(userIcon)),
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 25.0),
                      filled: true,
                      hintText: "Password",
                      prefixIcon: IconButton(
                        onPressed: () {}, icon: SvgPicture.asset(keyIcon)),
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
                      insertrecord();
                      
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
                          "In case you can feash any problem then contact Our Suppert Team ",
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
