import 'package:flutter/material.dart';
import 'package:flutter_application_1/Attendanance.dart';
import 'package:flutter_application_1/mobile/mob_task_mgmt.dart';
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
    String userID = prefs.getString('userID') ?? '';
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
        name = firstElement['name'];
        return name; // Return the 'name' value
      } else {
        setState(() {
          name = 'Data not found';
        });
        return 'Data not found'; // Return an appropriate value when data is not found
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchDataMonthly(int year, int month) async {
    String result = await initializeData();

    var url = Uri.parse(
        'https://creativecollege.in/Flutter/Attendance_data.php?id=${result}&filter=Monthly&year=$year&month=$month');

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
    // Reverse the order of items
    List<dynamic> reversedItems = List.from(items.reversed);

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
                    SizedBox(
                      width: 8,
                    ),
                    IconButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        icon: Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: 8,
                    )
                  ],
                )),
          ),
        ],
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: FadeInUp(
              // Wrap the widget with the FadeInUp animation
              duration: const Duration(milliseconds: 1000),
              child: ListView.builder(
                itemCount: reversedItems.length,
                itemBuilder: (BuildContext context, int index) {
                  // Extract month from the date in 'YYYY-MM-DD' format
                  int monthFromData =
                      int.parse(reversedItems[index]['DATE'].split('-')[1]);

                  // Check if the month matches the selected month
                  if (monthFromData == selectedDate!.month) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        elevation: 3,
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      'Date: ${reversedItems[index]['DATE']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      'Check In: ${reversedItems[index]['CHECK_IN_TIME']}',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      'Check Out: ${reversedItems[index]['CHECK_OUT_TIME']}',
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                'Present',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
      floatingActionButton: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: _color1),
            borderRadius: const BorderRadius.all(Radius.circular(18))),
        child: FloatingActionButton(
          backgroundColor: _color2,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Leave_Page(),
              ),
            );
          },
          child: const Icon(
            Icons.leave_bags_at_home,
            size: 30,
          ),
        ),
      ),
    );
  }
}
