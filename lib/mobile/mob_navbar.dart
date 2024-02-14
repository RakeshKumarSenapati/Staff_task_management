import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/mobile/Report_Upload.dart';
import 'package:flutter_application_1/mobile/Staff_Attendance.dart';
import 'package:flutter_application_1/mobile/mob_task_mgmt.dart';
import 'package:flutter_application_1/mobile/mob_contact_prev.dart';
import 'package:flutter_application_1/mobile/detailsMobile.dart';
import 'package:flutter_application_1/mobile/pdfView.dart';
import 'package:flutter_application_1/scanner_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/mobile/Report_retrive.dart';
import 'package:http/http.dart' as http;

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _currentIndex = 2;
  late String pickedImagePath;
  final List<Widget> _pages = [
    QrCodeScanner(),
    ContactPrev(),
    DetailsMobile(),
    Task_mgmt(),
    Staff_Attendanance(),
    Report(),
    Report_Retrive(),
  ];

  String name = '';

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? '';
    final response = await http.get(
        Uri.parse('https://creativecollege.in/Flutter/Profile.php?id=$userID'));

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
    loadImagePath();
    fetchData();
  }



  Future<void> loadImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedImagePath = prefs.getString('pickedImagePath');

    setState(() {
      if (savedImagePath != null) {}
    });
  }



  @override
  Widget build(BuildContext context) {
    // const _color2 = Color(0xFFF09FDE);
    return Scaffold(
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
                if (index == 2) {
                  // _showContactDialog(context);
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
                icon: Icon(Icons.contact_phone),
                label: 'Student Contact',
                backgroundColor: Color(0xFFC21E56),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Task Details',
                backgroundColor: Color(0xFFC21E56),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.task),
                label: 'Task Management',
                backgroundColor: Color(0xFFC21E56),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.present_to_all),
                label: 'Attendnance',
                backgroundColor: Color(0xFFC21E56),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.report),
                label: 'Attendnance',
                backgroundColor: Color(0xFFC21E56),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.report_rounded),
                label: 'Attendnance',
                backgroundColor: Color(0xFFC21E56),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
