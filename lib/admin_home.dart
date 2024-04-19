import 'package:flutter/material.dart';
import 'package:flutter_application_1/Admin_Contact.dart';
import 'package:flutter_application_1/Admin_DashBoard.dart';
import 'package:flutter_application_1/Admin_DateWise_Work_View.dart';
import 'package:flutter_application_1/Admin_leave_Mgmt.dart';
import 'package:flutter_application_1/Staff_List.dart';
import 'package:flutter_application_1/Add_staff.dart';
import 'package:flutter_application_1/Total_Present.dart';
import 'package:flutter_application_1/del_staff.dart';
import 'package:flutter_application_1/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    StaffList(),
    // StaffAdd(),
    Admin_Dashboard(),
    
    
    // AdminDateWiseWork(),
    // Admin_Leave_Page(),
    // Admin_ContactPrev(),
    Total_Attendance()
  ];

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('isLoggedInAdmin');
    await prefs.remove('userID');
    await prefs.remove('password');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const _color1 = Color.fromARGB(255, 194, 30, 86);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _color1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                Icons.logout,
                size: 40,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white, // Set background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ), // Set rounded corner
                      title: Text(
                        "Confirm Logout",
                        style: TextStyle(
                          color: Colors.black, // Set title text color
                        ),
                      ),
                      content: Text(
                        "Are you sure you want to logout?",
                        style: TextStyle(
                          color: Colors.black, // Set content text color
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color:
                                  Colors.blue, // Set cancel button text color
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            clearSharedPreferences();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.red, // Set logout button text color
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
        title: Text(
          'Hi.. ,  Admin',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
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
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.work),
                  label: 'Work Status',
                  backgroundColor: _color1),

              
              BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_customize),
                  label: 'Dashboard',
                  backgroundColor: _color1),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.delete),
              //     label: 'Delete Staff',
              //     backgroundColor: _color1),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.present_to_all_outlined),
              //     label: 'Leave',
              //     backgroundColor: _color1),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.contact_phone),
              //     label: 'Student Contacts',
              //     backgroundColor: _color1),
              BottomNavigationBarItem(
                  icon: Icon(Icons.co_present_outlined),
                  label: 'Atendance',
                  backgroundColor: _color1),
            ],
          ),
        ),
      ),
    );
  }
}
