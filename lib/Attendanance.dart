import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Attendanance extends StatefulWidget {
  const Attendanance({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  State<Attendanance> createState() => _StaffListState();
}

class _StaffListState extends State<Attendanance> {
  List<dynamic> items = [];
  DateTime? selectedDate;

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

  Future<void> fetchDataMonthly(int year, int month) async {
    var url = Uri.parse(
        'https://creativecollege.in/Flutter/Attendance_data.php?id=${widget.name}&filter=Monthly&year=$year&month=$month');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue)),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text('Select Monthly'),
              ),
              SizedBox(width: 16),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                // Extract month from the date in 'YYYY-MM-DD' format
                int monthFromData =
                    int.parse(items[index]['DATE'].split('-')[1]);

                // Check if the month matches the selected month
                if (monthFromData == selectedDate!.month) {
                  return Padding(
                    padding: EdgeInsets.all(8), // Add padding around the Card
                    child: Card(
                      elevation: 3,
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          8), // Add padding to the left and right
                                  child: Text(
                                    'Date: ${items[index]['DATE']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          8), // Add padding to the left and right
                                  child: Text(
                                    'Check In: ${items[index]['CHECK_IN_TIME']}',
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          8), // Add padding to the left and right
                                  child: Text(
                                    'Check Out: ${items[index]['CHECK_OUT_TIME']}',
                                  ),
                                ),
                              ],
                            ),
                            // Add Present text with blue color
                            Text(
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
                  // Return an empty container if the month doesn't match
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
