import 'dart:convert';
import 'package:flutter/material.dart';
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
  final List<Widget> _pages = [
    QrCodeScanner(),
    Mob_Add_Task(),
    DetailsMobile(),
    DetailsMobile(),
    Task_mgmt(),
  ];

  String name = '';

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? '';
    final response = await http.get(Uri.parse('https://creativecollege.in/Flutter/Profile.php?id=$userID'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData is List && jsonData.isNotEmpty) {
        final firstElement = jsonData[0];
        setState(() {
          name = firstElement['name'];
        });
      } else {
        setState(() {
          name = 'Data not found';
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _showContactDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ContactPrev(); // Show ContactPrev screen directly
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(100),
            bottomRight: Radius.circular(100),
          ),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                Icons.person,
                size: 40,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
            ),
          ),
        ],
        title: Text('HI $name'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          color: Color(0xFFC21E56),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
                if (index == 3) {
                  _showContactDialog(context);
                }
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code),
                label: 'Attendance',
                backgroundColor: Color(0xFFC21E56),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_task),
                label: 'Add Task',
                backgroundColor: Color(0xFFC21E56),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Task Details',
                backgroundColor: Color(0xFFC21E56),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contact_phone),
                label: 'Student Contact',
                backgroundColor: Color(0xFFC21E56),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.task),
                label: 'Task Management',
                backgroundColor: Color(0xFFC21E56),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
