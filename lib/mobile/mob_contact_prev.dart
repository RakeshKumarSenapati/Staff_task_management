import 'package:flutter/material.dart';
import 'package:flutter_application_1/mobile/mob_contact.dart';

class ContactPrev extends StatefulWidget {
  const ContactPrev({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ContactPrev> createState() => _ContactPage();
}

class _ContactPage extends State<ContactPrev> {
  Map<String, bool> isYearVisible = {
    'BSC': false,
    'BCA': false,
    'BBA': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            CardItem('BSC'),
            CardItem('BCA'),
            CardItem('BBA'),
          ],
        ),
      ),
    );
  }

  Widget CardItem(String course) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(course),
            trailing: Icon(isYearVisible[course]!
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down),
            onTap: () {
              setState(() {
                isYearVisible[course] = !isYearVisible[course]!;
              });
            },
          ),
          if (isYearVisible[course]!)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                
                ElevatedButton(onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Contact(
                      course: course,
                     year: '1st',
                    ),
                  ),
                );  }, child: Text("1st")),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Contact(
                      course: course,
                     year: '2nd',
                    ),
                  ),
                );
                }, child: Text("2nd")),
                
                ElevatedButton(onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Contact(
                      course: course,
                     year: '3rd',
                    ),
                  ),
                );
                }, child: Text("3rd")),
              ],
            ),
        ],
      ),
    );
  }
}
