import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StaffList extends StatefulWidget {
  const StaffList({super.key});

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {

  List<dynamic> items = [];

  Future<void> fetchData() async{
    var url = Uri.parse('https://creativecollege.in/Flutter/staff_list.php');

    var response = await http.get(url);

    if (response.statusCode == 200){
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
        title: Text('Login to Staff'),
        backgroundColor: Color.fromARGB(255, 191, 1, 243)
      ),
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
          // Handle button press for this item
        },
        child: Text('Login'),
      ),
    );
  }
}