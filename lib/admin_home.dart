import 'package:flutter/material.dart';
import 'package:flutter_application_1/DeleteWork.dart';
import 'package:flutter_application_1/Staff_List.dart';
import 'package:flutter_application_1/Add_staff.dart';
import 'package:flutter_application_1/del_staff.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/mobile/mob_contact_prev.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = [StaffList(), StaffAdd(), StaffDelete(),WorkDelete(), ContactPrev()];


  Future<void> clearSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('isLoggedIn');
  await prefs.remove('userID');
  await prefs.remove('password');
  
  // Navigate to the login screen and remove all routes from the stack
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => MyApp()),
    (Route<dynamic> route) => false,
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                Icons.logout,
                size: 40,
              ),
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Web_Login_Page()));
                clearSharedPreferences();
              },
            ),
          ),
        ],
        title: Text('Hi.. ,  Admin'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        color: Colors.blue,
        child: BottomNavigationBar(
          
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
           BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Work Ststus',
                backgroundColor: Color.fromARGB(255, 191, 1, 243)),
            BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Add Staff',
                backgroundColor: Color.fromARGB(255, 4, 203, 1)),
            BottomNavigationBarItem(
                icon: Icon(Icons.delete),
                label: 'Delete Staff',
                backgroundColor:Color.fromARGB(255, 255, 0, 0)),
            BottomNavigationBarItem(
                icon: Icon(Icons.delete_rounded),
                label: 'Delete Work',
                backgroundColor:Color.fromARGB(255, 226, 72, 1)),
            BottomNavigationBarItem(
                icon: Icon(Icons.contact_phone),
                label: 'Student Contacts',
                backgroundColor:Color.fromARGB(255, 1, 147, 226)),
                
          ],
        ),
      ),
    );
  }
}
