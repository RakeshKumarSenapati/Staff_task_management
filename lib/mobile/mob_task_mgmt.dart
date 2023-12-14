import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart'; // Import the package

class Task_mgmt extends StatefulWidget {
  Task_mgmt({Key? key}) : super(key: key);

  @override
  _Task_mgmt createState() => _Task_mgmt();
}

class _Task_mgmt extends State<Task_mgmt> {
  List<dynamic> data = [];
  String Course = '';
  String Year = '';

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? '';
    var url = Uri.parse(
        'https://creativecollege.in/Flutter/Task_mgmt.php?id=$userID');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          bool isNotStarted = data[index]['STATUS'] == 'Not Started';
          bool isNoStarted = data[index]['STATUS'] == 'Completed';
          bool isNStarted = data[index]['STATUS'] == 'Started';

          return Center(
            child: FadeInRightBig( // Wrap the entire Card with FadeInUp animation
              duration: const Duration(milliseconds: 1000),
              delay: Duration(milliseconds: index * 500),
              child: Card(
                elevation: 8,
                child: ExpansionTile(
                  title: Container(
                    margin: const EdgeInsets.only(left: 16.0, top: 5, bottom: 15),
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
                                    color: Color.fromARGB(255, 218, 22, 22)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          if (isNotStarted)
                            OutlinedButton(
                              onPressed: () {
                                String title = '${data[index]['TITLE']}';
                                String statuss = 'Started';

                                STARTIT(statuss, title).then((_) {
                                  fetchData();
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                  side: const BorderSide(
                                    color: Colors.blue,
                                  )),
                              child: const Text(
                                " Get Start ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          else if (isNoStarted)
                            const Text(
                              "Completed",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 218, 22, 22)),
                            )
                          else if (isNStarted)
                            OutlinedButton(
                              onPressed: () {
                                String title = '${data[index]['TITLE']}';
                                String statuss = 'Completed';
                                STARTIT(statuss, title).then((_) {
                                  fetchData();
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.green,
                                  side: BorderSide(
                                    color: Colors.green,
                                  )),
                              child: const Text(
                                "Complete",
                                style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}
