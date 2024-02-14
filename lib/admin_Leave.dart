import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Admin_Leave extends StatefulWidget {
  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<Admin_Leave> {
  TextEditingController reason = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  List<dynamic> data = [];
  String name = '';


  Future<void> fetchData() async {
    var url = Uri.parse('https://creativecollege.in/Flutter/Leave_Data.php');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        List<dynamic> pendingData = json.decode(response.body);
        data =
            pendingData.where((item) => item['Status'] == 'Pending').toList();
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Error fetching data',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }


  Future<void> _status(String Reason, String Startdate, String Status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? '';
    final response = await http.post(
      Uri.parse('https://creativecollege.in/Flutter/Leave_status.php'),
      body: {
        'ID': userID.trim(),
        'reason': Reason,
        'startdate': Startdate,
        'Status': Status
      },
    );


    Fluttertoast.showToast(
      msg: response.body,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    reason.text = '';
  }

  // Future<void> _Delete(String Reason, String Startdate) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String userID = prefs.getString('userID') ?? '';
  //   final response = await http.post(
  //     Uri.parse('https://creativecollege.in/Flutter/Delete_Leave.php'),
  //     body: {
  //       'ID': userID.trim(),
  //       'reason': Reason,
  //       'startdate': Startdate,
  //     },
  //   );

  //   Fluttertoast.showToast(
  //     msg: response.body,
  //     gravity: ToastGravity.BOTTOM,
  //     backgroundColor: Colors.green,
  //     textColor: Colors.white,
  //   );
  //   reason.text = '';
  // }

  @override
  void initState() {
    super.initState();
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
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
                    children: [],
                  )),
            ),
          ],
          title: Text(
            'Leave Request',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'Name: ${data[index]['Name']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reason: ${data[index]['Reason']}'),
                        Text('Start Date: ${data[index]['Start_Date']}'),
                        Text('Last Date: ${data[index]['Last_Date']}'),
                        Text(
                          'Status: ${data[index]['Status']}',
                          style: TextStyle(
                            color: getStatusColor(data[index]['Status']),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    String reason = data[index]['Reason'];
                                    String startDate =
                                        data[index]['Start_Date'];
                                    String Status = 'Rejected';
                                    _status(reason, startDate, Status)
                                        .then((value) => {fetchData()});
                                  },
                                  child: Text(' Reject ')),
                              ElevatedButton(
                                  onPressed: () {
                                    String reason = data[index]['Reason'];
                                    String startDate =
                                        data[index]['Start_Date'];
                                    String Status = 'Approved';
                                    _status(reason, startDate, Status)
                                        .then((value) => {fetchData()});
                                  },
                                  child: Text(' Approve ')),
                              // GestureDetector(
                              //   onTap: () {
                              //     String reason = data[index]['Reason'];
                              //     String startDate = data[index]['Start_Date'];
                              //     _Delete(reason, startDate).then((value) => {
                              //           fetchData(),
                              //         });
                              //   },
                              //   child: Icon(
                              //     Icons.delete,
                              //     color: Colors.red,
                              //   ),
                              // ),
                            ])
                      ],
                    ),
                  ),
                  if (index < data.length - 1) Divider(),
                ],
              );
            },
          ),
        ));
  }
}


Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.red; // Choose the color for Pending status
    case 'approved':
      return Colors.green; // Choose the color for Approved status
    case 'rejected':
      return Colors.red; // Choose the color for Rejected status
    default:
      return Colors.black; // Choose a default color or customize as needed
  }
}
