import 'package:flutter/material.dart';

class StaffList extends StatefulWidget {
  const StaffList({super.key});

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {

  final List<String> items = ["Bhabani Shankar Sahoo", "Rakesh Kumar Senapati",];

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
          return ListItemWithButton(item: items[index]);
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
        child: Text('Login'),
      ),
    );
  }
}