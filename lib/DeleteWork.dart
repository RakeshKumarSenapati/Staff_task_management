import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart'; // Import the animate_do package

class WorkDelete extends StatefulWidget {
  const WorkDelete({Key? key}) : super(key: key);

  @override
  State<WorkDelete> createState() => _WorkDeleteState();
}


class _WorkDeleteState extends State<WorkDelete> {
  List<dynamic> items = [];

  Future<void> fetchData() async {
    var url =
        Uri.parse('https://creativecollege.in/Flutter/Admin_Fetch_Work.php');

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
    // Reverse the order of items
    List<dynamic> reversedItems = List.from(items.reversed);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delete Work',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
      body: ListView.builder(
        itemCount: reversedItems.length,
        itemBuilder: (BuildContext context, int index) {
          return FadeInUp(
            // Wrap your widget with FadeInUp
            duration: Duration(milliseconds: 200),
            delay: Duration(
                milliseconds: 50 * index), // Apply different delay to each item
            child: Card(
              elevation: 3,
              margin: EdgeInsets.all(8),
              child: ListItemWithButton(
                item: '${reversedItems[index]['TITLE']}',
                item2: '${reversedItems[index]['STATUS']}',
                item3: '${reversedItems[index]['sl']}',
                item4: '${reversedItems[index]['ID']}',
                fetchData: fetchData,
              ),
            ),
          );
        },
      ),
    );
  }
}


class ListItemWithButton extends StatelessWidget {
  final String item;
  final String item2;
  final String item3;
  final String item4;
  final Function fetchData;

  ListItemWithButton({
    required this.item,
    required this.fetchData,
    required this.item2,
    required this.item3,
    required this.item4,
  });

  Future<void> delete(String title, String sl) async {
    var url = Uri.parse(
        'https://creativecollege.in/Flutter/Admin_Delete_Work.php?title=$title&sl=$sl');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      if (response.body == 'Success') {
        Fluttertoast.showToast(
          msg: response.body,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
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
    return ListTile(
      title: Text("Title: $item"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Status: $item2"),
          Text("Assigned To: $item4"),
        ],
      ),
      trailing: ElevatedButton(
        onPressed: () {
          delete(item, item3).then((value) {
            fetchData();
          });
        },
        style: ElevatedButton.styleFrom(
          primary: const Color.fromARGB(255, 243, 33, 33),
        ),
        child: Text('Delete', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
