import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart'; // Import the animate_do package

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
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return FadeInLeft( // Wrap your widget with FadeInUp
            duration: Duration(milliseconds: 1000),
            delay: Duration(milliseconds: index * 300),
            child: StaffCard(item: items[index], fetchData: fetchData),
          );
        },
      ),
    );
  }
}

class StaffCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function fetchData;

  StaffCard({required this.item, required this.fetchData});

  Future<void> delete(String name) async {
    var url = Uri.parse('https://creativecollege.in/Flutter/Delete_staff.php?name=$name');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      if (response.body == 'Success') {
        Fluttertoast.showToast(
          msg: response.body,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // After a successful delete, refresh the data
        fetchData();
      } else {
        Fluttertoast.showToast(
          msg: response.body,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 175, 76, 76),
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          title: Text(item['name']),
          trailing: ElevatedButton(
            onPressed: () {
              delete(item['name']);
            },
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 243, 33, 33),
            ),
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
