import 'package:flutter/material.dart';
import 'package:flutter_application_1/mobile/detailsMobile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_application_1/mobile/mob_navbar.dart';
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

class HomePage extends StatelessWidget {


  Future<void> ATTENDANCE() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? '';
    var url = Uri.parse('https://creativecollege.in/Flutter/Attendance.php?userID=$userID');

    var response = await http.get(url);
    if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: response.body,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
       
      
    }
    }
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Management System'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.calendar_today,
              size: 120,
              color: Colors.yellow,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to AMS',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Streamline Attendance Tracking',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 40),
        
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate to mark attendance page
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.yellow,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: GestureDetector(
              onTap: () {
                ATTENDANCE();
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NavPage()),
                result: MaterialPageRoute(builder: (context) => NavPage()),
              );
              },
              child: const Text(
                'Mark Attendance',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            )
            ),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     // Navigate to view attendance reports page
            //   },
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.black,
            //     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            //   ),
            //   child: Text(
            //     'View Attendance Reports',
            //     style: TextStyle(
            //       fontSize: 18,
            //       color: Colors.yellow,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}