import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class WorkDelete extends StatefulWidget {
  const WorkDelete({super.key});

  @override
  State<WorkDelete> createState() => _WorkDeleteState();
}

class _WorkDeleteState extends State<WorkDelete> {
  List<dynamic> items = [];

  Future<void> fetchData() async {
    var url = Uri.parse('https://creativecollege.in/Flutter/Admin_Fetch_Work.php');

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
        title: Text('Delete Work'),
        backgroundColor: Color.fromARGB(255, 255, 0, 0),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListItemWithButton(item: '${items[index]['TITLE']}',item2: '${items[index]['STATUS']}',item3: '${items[index]['sl']}',item4: '${items[index]['ID']}', fetchData: fetchData);
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

  ListItemWithButton({required this.item, required this.fetchData, required this.item2, required this.item3, required this.item4});

  Future<void> delete(String title,String sl) async {
    var url = Uri.parse('https://creativecollege.in/Flutter/Admin_Delete_Work.php?title=$title&sl=$sl');

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
      title: Text("title : $item"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Status: $item2"),
          Text("Assigned To: $item4"),
        ],
      ),
      trailing: ElevatedButton(
        onPressed: () {
          delete(item,item3).then((value) {
            fetchData();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 243, 33, 33), // Change the button's background color here
        ),
        child: Text('Delete'),
      ),
    );
  }
}
