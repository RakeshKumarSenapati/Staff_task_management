import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/mobile/mob_Profile.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';

class Task_mgmt extends StatefulWidget {
  Task_mgmt({Key? key}) : super(key: key);

  @override
  _Task_mgmt createState() => _Task_mgmt();
}

class _Task_mgmt extends State<Task_mgmt> {
  List<dynamic> data = [];
  String Course = '';
  String Year = '';
  XFile? _pickedImage;
  late String pickedImagePath;
  String filterStatus = 'All'; // Default filter
  int activeCount = 0;
  int pendingCount = 0;
  int completedCount = 0;

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? '';
    var url = Uri.parse(
        'https://creativecollege.in/Flutter/Task_mgmt.php?id=$userID');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
        updateCounts(); // Update counts after fetching data
      });
    } else {
      Fluttertoast.showToast(
        msg: 'No Task Added',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
  }

  Future<void> STARTIT(String Status, String title) async {
    final response = await http.post(
      Uri.parse('https://creativecollege.in/Flutter/Task_operation.php'),
      body: {
        'STATUS': Status,
        'TITLE': title,
      },
    );

    if (response.body == 'Success') {
      Fluttertoast.showToast(
        msg: 'UPDATED',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'UPDATE FAILED',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
  }

  Future<void> loadImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedImagePath = prefs.getString('pickedImagePath');

    setState(() {
      if (savedImagePath != null) {
        _pickedImage = XFile(savedImagePath);
      }
    });
  }

  void updateCounts() {
    activeCount = data.where((task) => task['STATUS'] == 'Started').length;
    pendingCount = data.where((task) => task['STATUS'] == 'Not Started').length;
    completedCount = data.where((task) => task['STATUS'] == 'Completed').length;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    loadImagePath();
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
        title: Text(
          'Manage Task',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: DropdownButton<String>(
              value: filterStatus,
              onChanged: (String? newValue) {
                setState(() {
                  filterStatus = newValue!;
                });
              },
              items: <String>['All', 'Pending', 'Active']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                );
              }).toList(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: _pickedImage == null
                    ? AssetImage('assets/images/technocart.png')
                    : FileImage(File(_pickedImage!.path))
                        as ImageProvider<Object>?,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active: $activeCount',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Pending: $pendingCount',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                // Text('Completed: $completedCount',style: TextStyle(fontSize: 17)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                bool isNotStarted = data[index]['STATUS'] == 'Not Started';
                bool isNoStarted = data[index]['STATUS'] == 'Completed';
                bool isNStarted = data[index]['STATUS'] == 'Started';

                // Apply filter
                if (filterStatus == 'Pending' && !isNotStarted) {
                  return Container(); // Skip if not pending
                } else if (filterStatus == 'Active' && !isNStarted) {
                  return Container(); // Skip if not active
                }

                return Center(
                  child: FadeInLeftBig(
                    duration: const Duration(milliseconds: 400),
                    delay: Duration(milliseconds: index * 200),
                    child: Card(
                      elevation: 8,
                      child: ExpansionTile(
                        title: Container(
                          margin: const EdgeInsets.only(
                              left: 16.0, top: 5, bottom: 15),
                          child: ListTile(
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        '${data[index]['TITLE']}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      '${data[index]['STATUS']}',
                                      style: const TextStyle(
                                          fontSize: 17,
                                          color:
                                              Color.fromARGB(255, 218, 22, 22)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                if (isNotStarted)
                                  OutlinedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            title: Text(
                                              "Confirm Start",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            content: Text(
                                              "Are you sure you want to start this task?",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  String title =
                                                      '${data[index]['TITLE']}';
                                                  String statuss = 'Started';
                                                  STARTIT(statuss, title)
                                                      .then((_) {
                                                    fetchData();
                                                  });
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: Text(
                                                  "Start",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.blue,
                                      side: BorderSide(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    child: Text(
                                      "Get Start",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                else if (isNoStarted)
                                  const Text(
                                    "Completed",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color:
                                            Color.fromARGB(255, 218, 22, 22)),
                                  )
                                else if (isNStarted)
                                  OutlinedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors
                                                .white, // Set background color
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ), // Set rounded corner
                                            title: Text(
                                              "Confirm Completion",
                                              style: TextStyle(
                                                color: Colors
                                                    .black, // Set title text color
                                                fontWeight: FontWeight
                                                    .bold, // Set title font weight
                                                fontSize:
                                                    18, // Set title font size
                                              ),
                                            ),
                                            content: Text(
                                              "Are you sure you want to mark this task as completed?",
                                              style: TextStyle(
                                                color: Colors
                                                    .black, // Set content text color
                                                fontSize:
                                                    16, // Set content font size
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color: Colors
                                                        .blue, // Set cancel button text color
                                                    fontSize:
                                                        16, // Set cancel button font size
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  String title =
                                                      '${data[index]['TITLE']}';
                                                  String statuss = 'Completed';
                                                  STARTIT(statuss, title)
                                                      .then((_) {
                                                    fetchData();
                                                  });
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: Text(
                                                  "Confirm",
                                                  style: TextStyle(
                                                    color: Colors
                                                        .red, // Set confirm button text color
                                                    fontSize:
                                                        16, // Set confirm button font size
                                                    fontWeight: FontWeight
                                                        .bold, // Set confirm button font weight
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.green,
                                      side: BorderSide(
                                        color: Colors.green,
                                      ),
                                    ),
                                    child: Text(
                                      "Complete",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                '${data[index]['DESCRIPTION']}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
