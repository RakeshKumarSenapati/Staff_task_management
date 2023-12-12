import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Attendanance.dart';
import 'package:flutter_application_1/Attendenanceprev.dart';
import 'package:flutter_application_1/mobile/mob_Profile.dart';
import 'package:flutter_application_1/mobile/mob_add_task.dart';
import 'package:flutter_application_1/mobile/mob_task_mgmt.dart';
import 'package:flutter_application_1/mobile/mob_contact_prev.dart';
import 'package:flutter_application_1/mobile/detailsMobile.dart';
import 'package:flutter_application_1/scanner_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _currentIndex = 2;
  final List<Widget> _pages = [QrCodeScanner(), Mob_Add_Task(), DetailsMobile(),  ContactPrev(),Task_mgmt()];

  String name = '';

    Future<void> fetchData() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? '';
    final response = await http.get(Uri.parse('https://creativecollege.in/Flutter/Profile.php?id=$userID'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      // Check if jsonData is a list and not empty
      if (jsonData is List && jsonData.isNotEmpty) {
        // Access the first element of the list (assuming there is only one element)
        final firstElement = jsonData[0];

        // Access the specific fields within the first element
        setState(() {
          name = firstElement['name'];
        });
      } else {
        // Handle the case where the JSON array is empty or not as expected
        setState(() {
          name = 'Data not found';
        });
      }
    } else {
      // Handle the HTTP error
      throw Exception('Failed to load data');
    }
  }

    @override
  void initState() {
    super.initState();
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(Icons.person, size: 40,),
                onPressed: () {
                  // Add your action here when the button is pressed.
                  // For example, you can open a search page or perform a search action.
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                },
              ),
            ),
          ],
        title: Text('HI $name'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        color: Colors.blue, 
        child: BottomNavigationBar(
          // fixedColor: Color.fromARGB(255, 0, 161, 51),
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'Attendance',
              backgroundColor: Color.fromARGB(255, 191, 1, 243)
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_task),
              label: 'Add Task',
              backgroundColor: Color.fromARGB(255, 255, 124, 1)
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Task Details',
              backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_phone),
              label: 'Student Contact',
              backgroundColor: Color.fromARGB(255, 35, 208, 0)
            ),
             BottomNavigationBarItem(
              icon: Icon(Icons.task),
              label: 'Task Management',
              backgroundColor: Color.fromARGB(255, 255, 0, 0)
            ),
            //  BottomNavigationBarItem(
            //   icon: Icon(Icons.attach_email_rounded),
            //   label: 'Task Management',
            //   backgroundColor: Color.fromARGB(255, 255, 0, 0)
            // ),
          ],
        ),
      ),
    );
  }
}

