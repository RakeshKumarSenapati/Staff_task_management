import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StaffDelete extends StatefulWidget {
  const StaffDelete({super.key});

  @override
  State<StaffDelete> createState() => _StaffDeleteState();
}

class _StaffDeleteState extends State<StaffDelete> {

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
        title: Text('Delete Staff'),
        backgroundColor: Color.fromARGB(255, 255, 0, 0),
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
          print('Button pressed for $item');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 243, 33, 33), // Change the button's background color here
        ),
        child: Text('Delete'),
      ),
    );
  }
}