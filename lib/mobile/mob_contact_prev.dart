import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final BorderRadiusGeometry borderRadius;

  const CustomAppBar({required this.title, required this.borderRadius});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: const Color(0xFFC21E56),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
    );
  }
}

class ContactPrev extends StatefulWidget {
  const ContactPrev({Key? key}) : super(key: key);

  @override
  State<ContactPrev> createState() => _ContactPage();
}

class _ContactPage extends State<ContactPrev> {
  List<String> allowedCourses = ['BSC', 'BCA', 'BBA'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Selection'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                for (String course in allowedCourses)
                  CardItem(course, const Color(0xFFC21E56)),
              ],
            ),
          ),
        ),
      ),
    );
  }

 // ignore: non_constant_identifier_names
 Widget CardItem(String course, Color cardColor) {
  return Card(
    color: cardColor,
    margin: const EdgeInsets.only(top: 16),
    child: InkWell(
      onTap: () {
        _navigateToContactPage(course);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center( // Center the text within the button
          child: Text(
            course,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}


  void _navigateToContactPage(String course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Contact(course: course, year: ''),
      ),
    );
  }
}

class Contact extends StatefulWidget {
  final String course;
  final String year;

  Contact({Key? key, required this.course, required this.year})
      : super(key: key);

  @override
  _Contact createState() => _Contact();
}

class _Contact extends State<Contact> {
  int? expandedIndex;
  String selectedYear = '1st'; 
  directCall(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  List<dynamic> data = [];
  String Course = '';
  String Year = '';
  bool isExpanded = false;

  Future<void> fetchDataForYear() async {
    Course = widget.course;
    Year = selectedYear; // Use the selected year
    var url = Uri.parse(
        'https://creativecollege.in/Flutter/StudentContact.php?Course=$Course&Year=$Year');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      print('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataForYear();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    String telScheme = 'tel:$phoneNumber';
    if (await canLaunch(telScheme)) {
      await launch(telScheme);
    } else {
      throw 'Could not launch $telScheme';
    }
  }

  Widget _buildYearButton(String label, String year) {
    Color customColor = Color(0xFFC21E56);
    Color innerColor = Color(0xFFF09FDE);

    return Container(
      child: ElevatedButton(
        onPressed: () {
          selectedYear = year; // Update the selected year
          fetchDataForYear();
        },
        style: ElevatedButton.styleFrom(
          primary: innerColor,
          onPrimary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: customColor),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.center, // Center the text
            child: Text(
              label,
              style:
                  const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CONTACT'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(16.0),
        
            child: Card(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${data[index]['ID']}',
                                    style: TextStyle(fontSize: 18)),
                                Text('Name: ${data[index]['NAME']}',
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isExpanded
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                expandedIndex = (expandedIndex == index) ? null : index;
                              });
                            },
                          ),
                        ],
                      ),
                      if (expandedIndex == index)
                        Column(
                          children: [
                             Row(
                            children: [
                              Text('Student No: ${data[index]['MOB_NO']}',
                                  style: TextStyle(fontSize: 18)),
                              IconButton(
                                icon: Icon(Icons.call),
                                onPressed: () {
                                  String num = data[index]['MOB_NO'];
                                  directCall(num);
                                },
                              ),
                            ],
                          ),
                             Row(
                            children: [
                              Text('Father No: ${data[index]['F_MOB']}',
                                  style: TextStyle(fontSize: 18)),
                              IconButton(
                                icon: Icon(Icons.call),
                                onPressed: () {
                                  String num = data[index]['MOB_NO'];
                                  directCall(num);
                                },
                              ),
                            ],
                          ),
                             Row(
                            children: [
                              Text('Mother No: ${data[index]['M_MOB']}',
                                  style: TextStyle(fontSize: 18)),
                              IconButton(
                                icon: Icon(Icons.call),
                                onPressed: () {
                                  String num = data[index]['MOB_NO'];
                                  directCall(num);
                                },
                              ),
                            ],
                          ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
