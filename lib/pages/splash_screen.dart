import "dart:async";
import "package:flutter/material.dart";
import "package:flutter_application_1/pages/login_page.dart";
// import 'package:flutter_application_1/pages/dashboard.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  
 @override
  void initState() {
  
    super.initState();

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login_Page(),));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child:SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 150,),
               Image.asset('assets/images/Creative.gif',),
              const SizedBox(height: 210,),
              Row(
                
                 children: [
                 Container(
                    margin: const EdgeInsets.fromLTRB(100, 0, 0, 0),
                    child: const Text("Developed By TechnoCart ",style: TextStyle(color: Colors.white,)),
                  ),
                 Image.asset("assets/images/technocart.png",height: 30,width: 30,),
                ],
                ),
            ],
          ),
        )
      ),
    );
  }
}
