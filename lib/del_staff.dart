import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';

class StaffDelete extends StatefulWidget {
  const StaffDelete({Key? key}) : super(key: key);

  @override
  State<StaffDelete> createState() => _StaffDeleteState();
}

class _StaffDeleteState extends State<StaffDelete> {
  List<dynamic> items = [];

  Future<void> fetchData() async {
    var url = Uri.parse('https://creativecollege.in/Flutter/staff_list.php');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body);
        items.sort((a, b) => a['name'].compareTo(b['name']));
      });
    } else {
      print('Failed to load data');
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
        title: Text(
          'Delete Staff',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Remove app bar elevation
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return FadeInLeft(
            duration: Duration(milliseconds: 300),
            delay: Duration(milliseconds: index * 50),
            child: StaffCard(item: items[index], fetchData: fetchData),
          );
        },
      ),
      backgroundColor: Colors.grey[200], // Set background color
    );
  }
}

class StaffCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function fetchData;

  StaffCard({required this.item, required this.fetchData});

  Future<void> delete(String name) async {
    var url = Uri.parse(
        'https://creativecollege.in/Flutter/Delete_staff.php?name=$name');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      if (response.body == 'Success') {
        Fluttertoast.showToast(
          msg: 'Staff deleted successfully!',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        fetchData(); // Refresh the data after successful deletion
      } else {
        Fluttertoast.showToast(
          msg: response.body,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          title: Text(
            item['name'],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    title: Text(
                      "Confirm Delete",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      "Are you sure you want to delete ${item['name']}?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
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
                          delete(item['name']);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.red,
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
          ),
        ),
      ),
    );
  }
}
