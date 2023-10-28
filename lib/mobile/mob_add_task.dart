import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:fluttertoast/fluttertoast.dart';

// ignore: camel_case_types
class Mob_Add_Task extends StatefulWidget {
  const Mob_Add_Task({super.key});

  @override
  State<Mob_Add_Task> createState() => _Mob_Add_TaskState();
}

class _Mob_Add_TaskState extends State<Mob_Add_Task> {
  TextEditingController TITLE = TextEditingController();
  TextEditingController DESCRIPTION = TextEditingController();

  late String userID='';

  Future<void> retrieveStoredData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID') ?? '';
  }

  @override
  void initState() {
    super.initState();
    retrieveStoredData().then((_) {
      setState(() {}); // Set the state to rebuild the widget
    });
  }

  Future<void> _AddTaskk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    late String user = prefs.getString('userID') ?? '';
    final response = await http.post(
      Uri.parse('https://creativecollege.in/Flutter/AddTask.php'),
      body: {
        'TITLE': TITLE.text,
        'DESCRIPTION': DESCRIPTION.text,
        'userID': user,
        // 'STARTDATE': currentDate.toLocal(),
      },
    );
    if (response.statusCode == 200) {
      if (response.body == 'Success') {
        Fluttertoast.showToast(
          msg: 'WORK ADDED',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        DESCRIPTION.text='';
        TITLE.text='';
      } else {
        Fluttertoast.showToast(
          msg: 'Failed Loading',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }
    } else {
      // Fluttertoast.showToast(
      //   msg: 'EXCEPTION',
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Center(
                child: Text(
              "ADD WORKS",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            )),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      backgroundImage:
                          AssetImage("assets/images/technocart.png"),
                      radius: 40,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          "Hello",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          userID,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 12, right: 12),
              child: Container(
                  width: 400,
                  child: Column(
                    children: [
                      const Text(
                        "Title Of Work:-",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                      TextField(
                        controller: TITLE,
                        decoration: InputDecoration(
                            hintText: "Enter The  work",
                            // enabled: true,
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(232, 95, 1, 105),
                                    width: 2)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black, width: 1.5)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      )
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, right: 12, left: 12),
              child: Container(
                  width: 400,
                  child: Column(
                    children: [
                      const Text(
                        "Description Of Work:-",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                      SingleChildScrollView(
                        child: TextFormField(
                          controller: DESCRIPTION,
                          maxLines: null,
                          decoration: InputDecoration(
                              hintText: "Enter The description of work",
                              contentPadding: const EdgeInsets.only(
                                  top: 35.0,
                                  bottom: 35.0,
                                  left: 15.0,
                                  right: 15.0),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(232, 95, 1, 105),
                                      width: 2)),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.5)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 23),
                    child: ElevatedButton(
                      onPressed: () {
                       if(TITLE.text=='')
                       {
                           Fluttertoast.showToast(
                            msg: 'TITLE IS EMPTY',
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                          );
                       }
                       
                       else {
                          _AddTaskk();
                       }
                      },
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          elevation: MaterialStateProperty.all<double>(5.0),
                          shadowColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(100.0, 50.0)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                                side:
                                    BorderSide(color: Colors.black, width: 2)),
                          ),
                          overlayColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 51, 24, 148))),
                      child: const Text(
                        "Add",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 23),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          elevation: MaterialStateProperty.all<double>(5.0),
                          shadowColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          minimumSize: MaterialStateProperty.all<Size>(
                              Size(100.0, 50.0)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                                side:
                                    BorderSide(color: Colors.black, width: 2)),
                          ),
                          overlayColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 51, 24, 148))),
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w900),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 23),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Task description",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                        child: Text(
                      "more->",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue),
                    )),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 180,
                        height: 150,
                        child: Card(
                            elevation: 11,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Title ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                  "Description",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            )),
                      ),
                      Container(
                        width: 180,
                        height: 150,
                        margin: const EdgeInsets.only(left: 20),
                        child: const Card(
                            elevation: 5,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Title",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                  "Description",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
