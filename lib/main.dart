import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/dashboard.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: SplashScreen(),
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 0, 127, 139),
        fontFamily: GoogleFonts.lato().fontFamily),
      darkTheme: ThemeData(brightness: Brightness.dark),
      
      routes: {
        "/":(context) => const SplashScreen(),
        "/login": (context) => const Login_Page(),
        "/home": (context) => HomePage(),
      },
    );
  }
}
