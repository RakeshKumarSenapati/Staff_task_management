import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/mobile/pdfView.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';

class Report_Retrive extends StatefulWidget {
  final String id;
  final String name;

  Report_Retrive({required this.id, required this.name});

  @override
  State<Report_Retrive> createState() => _RetriveState();
}

class _RetriveState extends State<Report_Retrive> {
  List<dynamic> items = [];
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  late String selectedMonth; // Declare selectedMonth as late

  @override
  void initState() {
    super.initState();
    // Initialize selectedMonth with current month
    selectedMonth = months[DateTime.now().month - 1];
    fetchData();
  }

  Future<void> fetchData() async {
    var url =
        Uri.parse('https://creativecollege.in/Flutter/Retrive_Report.php');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        List<dynamic> allItems = json.decode(response.body);
        items = allItems
            .where((item) =>
                item['ID'] == widget.id && item['Month'] == selectedMonth)
            .toList();

        if (items.isEmpty) {
          Fluttertoast.showToast(msg: 'No files available of $selectedMonth');
        } else {
          Fluttertoast.showToast(msg: 'Showing files of $selectedMonth');
        }
      });
    } else {
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    const _color1 = Color(0xFFC21E56);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _color1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: Text(
          '${widget.name} Report',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: selectedMonth,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMonth = newValue!;
                });
                fetchData(); // Refetch data based on the selected month
              },
              items: months.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 16.0),
                  ),
                );
              }).toList(),
              style: TextStyle(color: Colors.black),
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 36.0,
              elevation: 16,
              isExpanded: true,
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return FadeInLeft(
                  duration: Duration(milliseconds: 300),
                  delay: Duration(milliseconds: index * 50),
                  child: StaffCard(item: items[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StaffCard extends StatelessWidget {
  final Map<String, dynamic> item;

  StaffCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          title: Text(
            item['Filename'],
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
          ),
          subtitle: Text(item['Month']),
          onTap: () {
            String name = item['Filename'];
            if (kIsWeb) {
              // Running on web
              _launchURL(
                  "https://creativecollege.in/Flutter/Report/Pdflist.php?name=$name");
            } else {
              // Running on Android
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFViewer(
                    url:
                        "https://creativecollege.in/Flutter/Report/Pdflist.php?name=$name",
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
