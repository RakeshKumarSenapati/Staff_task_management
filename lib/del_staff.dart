import 'package:flutter/material.dart';

class StaffDelete extends StatefulWidget {
  const StaffDelete({super.key});

  @override
  State<StaffDelete> createState() => _StaffDeleteState();
}

class _StaffDeleteState extends State<StaffDelete> {

  final List<String> items = ["Bhabani Shankar Sahoo", "Rakesh Kumar Senapati",];

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
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 243, 33, 33), // Change the button's background color here
        ),
        child: Text('Delete'),
      ),
    );
  }
}