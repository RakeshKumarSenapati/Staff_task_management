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
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
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
      lastDate: DateTime(2023, 12, 31),
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
        title: Text('Work Status'),
        backgroundColor: Color.fromARGB(255, 191, 1, 243),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text('Select Monthly'),
              ),
              SizedBox(width: 16),
              DropdownButton<String>(
                value: selectedMonth,
                items: months.map((String month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(month),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMonth = newValue!;
                    int monthIndex = months.indexOf(selectedMonth) + 1;
                    fetchDataMonthly(selectedDate!.year, monthIndex);
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                // Extract month from the date in 'YYYY-MM-DD' format
                int monthFromData = int.parse(items[index]['DATE'].split('-')[1]);
                
                // Check if the month matches the selected month
                if (monthFromData == selectedDate!.month) {
                  return Card(
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
                              Text(
                                'Date: ${items[index]['DATE']}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text('Check In: ${items[index]['CHECK_IN_TIME']}'),
                              Text('Check Out: ${items[index]['CHECK_OUT_TIME']}'),
                            ],
                          ),
                        ],
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
