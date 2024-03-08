import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Total_Attendance extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<Total_Attendance> {
  String selectedMonth = 'January';
  String selectedYear = '2024';
  List<Map<String, dynamic>> attendanceData = [];

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('https://creativecollege.in/Flutter/Total_Attendanance.php'));
    if (response.statusCode == 200) {
      setState(() {
        List<dynamic> responseData = json.decode(response.body);

        attendanceData = responseData.map((dynamic item) {
          if (item is Map<String, dynamic>) {
            return item;
          } else {
            throw Exception('Unexpected data format');
          }
        }).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    const _color1 = Color(0xFFC21E56);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 12.0),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(8.0),
              //     color: Colors.grey[200],
              //   ),
              //   child: DropdownButton<String>(
              //     value: selectedMonth,
              //     onChanged: (String? newValue) {
              //       setState(() {
              //         selectedMonth = newValue!;
              //       });
              //     },
              //     items: [
              //       'January',
              //       'February',
              //       'March',
              //       'April',
              //       'May',
              //       'June',
              //       'July',
              //       'August',
              //       'September',
              //       'October',
              //       'November',
              //       'December'
              //     ].map<DropdownMenuItem<String>>((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(
              //           value,
              //           style: TextStyle(
              //             color: Colors.black,
              //           ),
              //         ),
              //       );
              //     }).toList(),
              //     dropdownColor: Colors.grey[200],
              //     icon: Icon(Icons.arrow_drop_down),
              //     elevation: 2,
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontSize: 16.0,
              //     ),
              //     underline: SizedBox(),
              //   ),
              // ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 12.0),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(8.0),
              //     color: Colors.grey[200],
              //   ),
              //   child: DropdownButton<String>(
              //     value: selectedYear,
              //     onChanged: (String? newValue) {
              //       setState(() {
              //         selectedYear = newValue!;
              //       });
              //     },
              //     items: <String>['2023', '2024', '2025','2026']
              //         .map<DropdownMenuItem<String>>((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(
              //           value,
              //           style: TextStyle(
              //             color: Colors.black,
              //           ),
              //         ),
              //       );
              //     }).toList(),
              //     dropdownColor: Colors.grey[200],
              //     icon: Icon(Icons.arrow_drop_down),
              //     elevation: 2,
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontSize: 16.0,
              //     ),
              //     underline: SizedBox(),
              //   ),
              // ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: attendanceData.length,
              itemBuilder: (context, index) {
                final item = attendanceData[index];
                if (item['year'] == '2024' ) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text(
                          item['Name'],
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              'Total Present  :',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '  ${item['Total_Present']}',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .green, // You can change the color based on your preference
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         _printPage(context);
  //       },
  //       child: Icon(Icons.print),
  //       backgroundColor: _color1,
  //     ),
  //   );
  }

}
