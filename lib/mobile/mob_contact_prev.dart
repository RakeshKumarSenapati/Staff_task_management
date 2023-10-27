import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


class ContactPrev extends StatefulWidget {
  const ContactPrev({Key? key}) : super(key: key);

  @override
  State<ContactPrev> createState() => _ContactPage();
}

class _ContactPage extends State<ContactPrev> {
  Map<String, bool> isYearVisible = {
    'BSC': false,
    'BCA': false,
    'BBA': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Selection'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CardItem('BSC', Colors.blue),
              CardItem('BCA', Colors.green),
              CardItem('BBA', Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget CardItem(String course, Color cardColor) {
    return Card(
      color: cardColor,
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          setState(() {
            isYearVisible[course] = !isYearVisible[course]!;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  course,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Select Year',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(
                  isYearVisible[course]!
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ),
              if (isYearVisible[course]!)
                Column(
                  children: [
                    YearButton(course, '1st Year', '1st'),
                    SizedBox(height: 8),
                    YearButton(course, '2nd Year', '2nd'),
                    SizedBox(height: 8),
                    YearButton(course, '3rd Year', '3rd'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget YearButton(String course, String label, String year) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: ElevatedButton(
        onPressed: () => _navigateToContactPage(course, year),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.black,
        ),
        child: Text(label),
      ),
    );
  }

  void _navigateToContactPage(String course, String year) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Contact(course: course, year: year),
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
  
  directCall(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  List<dynamic> data = [];
  String Course = '';
  String Year = '';
  bool isExpanded = false;

  Future<void> fetchData() async {
    Course = widget.course;
    Year = widget.year;
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
    fetchData();

    
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    String telScheme = 'tel:$phoneNumber';
    if (await canLaunch(telScheme)) {
      await launch(telScheme);
    } else {
      throw 'Could not launch $telScheme';
    }
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
                                    style: TextStyle(fontSize: 18)),
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
                              Text('Student Number: ${data[index]['MOB_NO']}',
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
                              Text('Father Number: ${data[index]['MOB_NO']}',
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
                              Text('Mother Number: ${data[index]['MOB_NO']}',
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
