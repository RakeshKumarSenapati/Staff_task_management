import 'package:flutter/material.dart';
import 'package:flutter_application_1/staff_leave.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Staff_Attendanance extends StatefulWidget {
  @override
  State<Staff_Attendanance> createState() => _StaffListState();
}

class _StaffListState extends State<Staff_Attendanance> {
  List<dynamic> items = [];
  DateTime? selectedDate;
  int totalPresent = 0;
  String name = '';

  final List<String> months = [
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

  String selectedMonth = '';
  Future<String> initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? ''.trim();
    final response = await http.get(
      Uri.parse('https://creativecollege.in/Flutter/Profile.php?id=$userID'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData is List && jsonData.isNotEmpty) {
        final firstElement = jsonData[0];
        setState(() {
          name = firstElement['name'];
        });
        name = firstElement['name'].toString().trim();
        return name;
      } else {
        setState(() {
          name = 'Data not found';
        });
        return 'Data not found'; 
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchDataMonthly(int year, int month) async {
    String result = await initializeData();

    var url = Uri.parse(
        'https://olivedrab-chicken-455066.hostingersite.com/Attendanance/staffAttendanance.php?id=${result}&filter=Monthly&year=$year&month=$month');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body);
        calculateTotalPresent();
      });
    } else {
      print('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();
    fetchDataMonthly(selectedDate!.year, selectedDate!.month);
    selectedMonth = months[selectedDate!.month - 1];
  }

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030, 12, 31),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedMonth = months[selectedDate!.month - 1];
      });

      // Fetch data based on the selected month
      fetchDataMonthly(selectedDate!.year, selectedDate!.month);
    }
  }

  void calculateTotalPresent() {
    totalPresent = 0;
    for (var item in items) {
      int monthFromData = int.parse(item['DATE'].split('-')[1]);
      if (monthFromData == selectedDate!.month) {
        totalPresent++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const _color2 = Color(0xFFF09FDE);
    const _color1 = Color(0xFFC21E56);

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
            margin: EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    '${totalPresent}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    icon: Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8)
                ],
              ),
            ),
          ),
        ],
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  int monthFromData =
                      int.parse(items[index]['DATE'].split('-')[1]);

                  if (monthFromData == selectedDate!.month) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text('Date: ${items[index]['DATE']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Check In: ${items[index]['CHECK_IN_TIME']}'),
                              Text(
                                  'Check Out: ${items[index]['CHECK_OUT_TIME']}'),
                            ],
                          ),
                          trailing: Text(
                            'Present',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20), // Add padding from the sides
                          child: Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
