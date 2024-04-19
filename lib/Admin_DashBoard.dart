import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Add_staff.dart';
import 'package:flutter_application_1/Admin_Contact.dart';
import 'package:flutter_application_1/Admin_DateWise_Work_View.dart';
import 'package:flutter_application_1/Admin_leave_Mgmt.dart';
import 'package:flutter_application_1/del_staff.dart';
import 'package:flutter_application_1/student_attendance.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mobile/mob_Profile.dart';

class Admin_Dashboard extends StatefulWidget {
  const Admin_Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Admin_Dashboard> {
  final _color1 = const Color(0xFFC21E56);
  XFile? _pickedImage;
  late String pickedImagePath;

  Future<void> loadImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedImagePath = prefs.getString('pickedImagePath');

    setState(() {
      if (savedImagePath != null) {
        _pickedImage = XFile(savedImagePath);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadImagePath();
  }

  Widget _buildCard(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return _buildSmallScreenView();
          } else {
            return _buildLargeScreenView();
          }
        },
      ),
    );
  }

  Widget _buildSmallScreenView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          _buildCard(Icons.work_history, 'Date Wise Work', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminDateWiseWork(),
              ),
            );
          }),
          _buildCard(Icons.delete_forever, 'Delete Staff', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StaffDelete(),
              ),
            );
          }),
          _buildCard(Icons.leave_bags_at_home_outlined, 'Staff Leave', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Admin_Leave_Page(),
              ),
            );
          }),
          _buildCard(Icons.present_to_all, 'Student Contact', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Admin_ContactPrev(),
              ),
            );
          }),
          _buildCard(Icons.add, 'Add Staff', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StaffAdd(),
              ),
            );
          }),
          _buildCard(Icons.present_to_all, 'Student Attendnance', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentAttendance(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLargeScreenView() {
    return Center(
      child: SizedBox(
        width: 800,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: [
              _buildCard(Icons.work_history, 'Date Wise Work', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminDateWiseWork(),
              ),
            );
          }),
          _buildCard(Icons.delete_forever, 'Delete Staff', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StaffDelete(),
              ),
            );
          }),
          _buildCard(Icons.leave_bags_at_home_outlined, 'Staff Leave', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Admin_Leave_Page(),
              ),
            );
          }),
          _buildCard(Icons.present_to_all, 'Student Contact', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Admin_ContactPrev(),
              ),
            );
          }),
          _buildCard(Icons.add, 'Add Staff', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StaffAdd(),
              ),
            );
          }),
          _buildCard(Icons.present_to_all, 'Student Attendnance', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentAttendance(),
              ),
            );
          }),
        ],
      ),
        ),
      ),
    );
  }
}
