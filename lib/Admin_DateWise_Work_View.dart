import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminDateWiseWork extends StatefulWidget {
  @override
  _AdminDateWiseWorkState createState() => _AdminDateWiseWorkState();
}

class _AdminDateWiseWorkState extends State<AdminDateWiseWork> {
  late DateTime _selectedDate; // Variable to store the selected date
  String _filterValue = 'All'; // Default filter value

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Initialize with the current date
  }

  Future<List<Map<String, dynamic>>> fetchData(DateTime selectedDate) async {
    final response = await http.get(Uri.parse(
        'https://creativecollege.in/Flutter/Track_Work.php?date=${selectedDate.toString()}'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(jsonData);

      // Filter data based on the selected date
      data = data.where((item) {
        DateTime itemDate = DateTime.parse(
            item['ADDDATE'] ?? '');
        return itemDate.year == selectedDate.year &&
            itemDate.month == selectedDate.month &&
            itemDate.day == selectedDate.day;
      }).toList();

      data.sort((a, b) => (a['ID'] ?? '').compareTo(b['ID'] ?? ''));

      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _setFilter(String value) {
    setState(() {
      _filterValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    const _color1 = Color.fromARGB(255, 194, 30, 86);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _color1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: Text(
          'Date : ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () =>
                _selectDate(context),
          ),
          PopupMenuButton<String>(
            onSelected: _setFilter,
            itemBuilder: (BuildContext context) {
              return ['All', 'Started', 'Not Started'].map((String choice) {
                String displayChoice = choice;
                if (choice == 'Started') {
                  displayChoice = 'Active';
                } else if (choice == 'Not Started') {
                  displayChoice = 'Pending';
                }
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(displayChoice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchData(_selectedDate),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Map<String, dynamic>> filteredData = snapshot.data!;
            if (_filterValue != 'All') {
              filteredData = filteredData
                  .where((work) => work['STATUS'] == _filterValue)
                  .toList();
            }
            return ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final work = filteredData[index];
                String status = work['STATUS'] ?? '';
                String dateToShow = status == 'Started'
                    ? work['STARTDATE'] ?? ''
                    : work['ADDDATE'] ?? '';
                String statusToShow =
                    status == 'Started' ? 'Active' : 'Pending';

                return ListTile(
                  title: Text(
                    work['name'] ?? '',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(work['TITLE'] ?? '',style: TextStyle(fontFamily: 'Times New Roman',),),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$statusToShow',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Times New Roman',
                          fontWeight: FontWeight.bold,
                          color: statusToShow == 'Active'
                              ? Colors.green
                              : statusToShow == 'Pending'
                                  ? Colors.red
                                  : Colors.black,
                        ),
                      ),
                      Text('Date: $dateToShow'),
                    ],
                  ),
                  
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
