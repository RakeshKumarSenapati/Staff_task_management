import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Leave_Page extends StatefulWidget {
  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<Leave_Page> {
  TextEditingController reason = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  List<dynamic> data = [];

  Future<void> fetchData() async {
  var url = Uri.parse('https://creativecollege.in/Flutter/Leave_Data.php');

  var response = await http.get(url);

  if (response.statusCode == 200) {
    List<dynamic> allData = json.decode(response.body);

  SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? '';
    List<dynamic> filteredData = allData.where((item) {
      // Replace 'userID' with the actual key in your data structure
      return item['ID'] == userID;
    }).toList();

    setState(() {
      data = filteredData;
    });

    if (filteredData.isEmpty) {
      Fluttertoast.showToast(
        msg: 'No Leave Found for userID: $userID',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
  } else {
    Fluttertoast.showToast(
      msg: 'Error fetching data',
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}


  Future<void> _leave() async {
    final String formattedStartDate =
        startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : '';
    final String formattedEndDate =
        endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? '';

    final response = await http.post(
      Uri.parse('https://creativecollege.in/Flutter/Staff_Leave.php'),
      body: {
        'ID': userID.trim(),
        'reason': reason.text,
        'start_date': formattedStartDate,
        'end_date': formattedEndDate,
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: FadeInUp(
                        duration: const Duration(milliseconds: 1600),
                        child: Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: const Center(
                            child: Text(
                              "Leave Request",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: const Duration(milliseconds: 1800),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color.fromRGBO(143, 148, 251, 1),
                          ),
                          boxShadow: [
                            const BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, .2),
                              blurRadius: 20.0,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                  ),
                                ),
                              ),
                              child: DateTimeFormField(
                                decoration: const InputDecoration(
                                  hintStyle: TextStyle(color: Colors.black45),
                                  errorStyle:
                                      TextStyle(color: Colors.redAccent),
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.event_note),
                                  labelText: 'Start Date',
                                ),
                                mode: DateTimeFieldPickerMode.date,
                                autovalidateMode: AutovalidateMode.always,
                                onDateSelected: (DateTime value) {
                                  setState(() {
                                    startDate = value;
                                  });
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                  ),
                                ),
                              ),
                              child: DateTimeFormField(
                                decoration: const InputDecoration(
                                  hintStyle: TextStyle(color: Colors.black45),
                                  errorStyle:
                                      TextStyle(color: Colors.redAccent),
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.event_note),
                                  labelText: 'End Date',
                                ),
                                mode: DateTimeFieldPickerMode.date,
                                autovalidateMode: AutovalidateMode.always,
                                onDateSelected: (DateTime value) {
                                  setState(() {
                                    endDate = value;
                                  });
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                maxLines: 3,
                                controller: reason,
                                decoration: InputDecoration(
                                  labelText: 'Reason For Leave',
                                  labelStyle: const TextStyle(
                                    color: Colors.blue,
                                  ),
                                  hintText: 'Enter your reason here',
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.blue,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1900),
                      child: InkWell(
                        onTap: () {
                          if (reason.text == '') {
                            Fluttertoast.showToast(
                              msg: "Reason Is Empty",
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                            );
                          } else if (startDate == null) {
                            Fluttertoast.showToast(
                              msg: "Please Select Start Date",
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                            );
                          } else if (endDate == null) {
                            Fluttertoast.showToast(
                              msg: "Please Select Last Date",
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                            );
                          } else {
                            _leave();

                            endDate = null;
                            startDate = null;
                            fetchData();
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => Staff_Attendanance(),
                            //   ),
                            // );
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Request",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1900),
                child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 280,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              'Reason: ${data[index]['Reason']}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Start Date: ${data[index]['Start_Date']}'),
                                Text('Last Date: ${data[index]['Last_Date']}'),
                              ],
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                               
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          if (index < data.length - 1) Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
