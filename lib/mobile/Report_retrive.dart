import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/mobile/pdfView.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart'; // Import the animate_do package

class Report_Retrive extends StatefulWidget {
  const Report_Retrive({Key? key}) : super(key: key);

  @override
  State<Report_Retrive> createState() => _StaffDeleteState();
}

class _StaffDeleteState extends State<Report_Retrive> {
  List<dynamic> items = [];

  Future<void> fetchData() async {
    var url =
        Uri.parse('https://creativecollege.in/Flutter/Retrive_Report.php');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delete Staff',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return FadeInLeft(
            // Wrap your widget with FadeInUp
            duration: Duration(milliseconds: 300),
            delay: Duration(milliseconds: index * 50),
            child: StaffCard(item: items[index], fetchData: fetchData),
          );
        },
      ),
    );
  }
}

class StaffCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function fetchData;

  StaffCard({required this.item, required this.fetchData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          title: Text(item['Filename']),
          onTap: () {
            
            String name = item['Filename'];
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PDFViewer(
                      url:
                          "https://creativecollege.in/Flutter/Report/Pdflist.php?name=$name")),
            );
          },
        ),
      ),
    );
  }
}
