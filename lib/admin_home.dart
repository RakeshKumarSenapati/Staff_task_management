import 'package:flutter/material.dart';
import 'package:flutter_application_1/Attendenanceprev.dart';
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

  final List<Widget> _pages = [StaffList(), StaffAdd(), StaffDelete(),WorkDelete(), ContactPrev(),Attendananceprev()];


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
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Web_Login_Page()));
                clearSharedPreferences();
              },
            ),
          ),
        ],
        title: Text('Hi.. ,  Admin'),
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
                if (index ==2) {
                  // _showContactDialog(context);
                }
              });
            },
            items: const [
           BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Work Ststus',
                backgroundColor: _color1),
            BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Add Staff',
                backgroundColor: _color1),
            BottomNavigationBarItem(
                icon: Icon(Icons.delete),
                label: 'Delete Staff',
                backgroundColor:_color1),
            BottomNavigationBarItem(
                icon: Icon(Icons.delete_rounded),
                label: 'Delete Work',
                backgroundColor:_color1),
            BottomNavigationBarItem(
                icon: Icon(Icons.contact_phone),
                label: 'Student Contacts',
                backgroundColor:_color1),
            BottomNavigationBarItem(
                icon: Icon(Icons.co_present_outlined),
                label: 'Atendance',
                backgroundColor:_color1),    
          ],
          ),
        ),
      ),
    );
  }
}
