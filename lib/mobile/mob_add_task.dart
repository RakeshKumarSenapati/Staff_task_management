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

  late String userID = '';

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
        DESCRIPTION.text = '';
        TITLE.text = '';
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
                          hintText: "Enter The Work",
                          hintStyle: TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(232, 95, 1, 105),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor:
                              Colors.white, // Background color of the TextField
                          filled:
                              true, // Fill the background with the specified color
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          prefixIcon: Icon(Icons.work,
                              color: Colors.grey), // Icon before the text
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              TITLE
                                  .clear(); // Clear the text when the clear icon is pressed
                            },
                          ),
                          // Add more styling options as needed
                        ),
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
                        maxLines: null, // Allows unlimited lines
                        decoration: InputDecoration(
                          hintText: "Enter The Description of Work",
                          hintStyle: TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(232, 95, 1, 105),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.all(
                              35), // Padding for the entire input field
                          // Additional padding to create space for the hint text when the text is not focused
                          isDense: true,
                          prefixIcon:
                              Icon(Icons.description, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              DESCRIPTION.clear();
                            },
                          ),
                          // Customize the appearance of the floating label
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: "Description",
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                      )
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
                        if (TITLE.text == '') {
                          Fluttertoast.showToast(
                            msg: 'TITLE IS EMPTY',
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                          );
                        } else {
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
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
