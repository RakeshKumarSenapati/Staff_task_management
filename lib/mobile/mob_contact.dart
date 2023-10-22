import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Contact extends StatefulWidget {
  final String course;
  final String year;

  Contact({Key? key, required this.course, required this.year}) : super(key: key);

  @override
  _Contact createState() => _Contact();
}

class _Contact extends State<Contact> {
  List<dynamic> data = [];
  String Course = ''; 
  String Year = ''; 

  Future<void> fetchData() async {
    Course = widget.course;
    Year = widget.year;
   var url = Uri.parse('https://creativecollege.in/Flutter/StudentContact.php?Course=$Course&Year=$Year');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      }
      );
    } else {
      print('Failed to load data');
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
        title: Text('CONTACT'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(left: 16.0, top: 5, bottom: 15),
            child: ListTile(
              title: Text('Name: ${data[index]['NAME']}', style: const TextStyle(fontSize: 17)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Id: ${data[index]['ID']}', style: const TextStyle(fontSize: 15)),
                  Text('Contact: ${data[index]['MOB_NO']}', style: const TextStyle(fontSize: 15)),
                  Text('Course: ${data[index]['COURSE']}', style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
