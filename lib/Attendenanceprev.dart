import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Attendanance.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/web/admin_details.dart';

class Attendananceprev extends StatefulWidget {
  const Attendananceprev({super.key});

  @override
  State<Attendananceprev> createState() => _StaffListState();
}

class _StaffListState extends State<Attendananceprev> {
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
          title: Text('Attendanance'),
          backgroundColor: Color.fromARGB(255, 191, 1, 243)),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListItemWithButton(item: '${items[index]['name']}');
        },
      ),
    );
  }
}

class ListItemWithButton extends StatelessWidget {
  final String item;

  ListItemWithButton({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item),
      trailing: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Attendanance(
                name: item,
              ),
            ),
          );
        },
        child: Text('Show Work Status'),
      ),
    );
  }
}
