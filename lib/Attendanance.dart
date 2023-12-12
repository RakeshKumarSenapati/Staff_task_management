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

  Future<void> fetchDataMonthly(DateTime selectedDate) async {
    var formattedDate = selectedDate.toLocal().toString().split(' ')[0];
    var url = Uri.parse(
        'https://creativecollege.in/Flutter/Attendance_data.php?id=${widget.name}&filter=Monthly&date=$formattedDate');

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
    fetchDataMonthly(selectedDate!);
  }

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(2022),
      lastDate: DateTime(2023, 12, 31), // Update lastDate to be later in the year
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      fetchDataMonthly(selectedDate!);
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
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context,
              int index) {
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
},
),
),
],
),
);
}
}
