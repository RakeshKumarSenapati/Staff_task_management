import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/web/admin_details.dart';
import 'package:flutter_application_1/mobile/Report_retrive.dart';
import 'package:animate_do/animate_do.dart';

class StaffList extends StatefulWidget {
  const StaffList({Key? key}) : super(key: key);

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
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
          'Staff List',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return FadeInDown(
            duration: Duration(milliseconds: 200),
            delay: Duration(milliseconds: 50 * index),
            child: StaffCard(item: items[index]),
          );
        },
      ),
    );
  }
}

class StaffCard extends StatelessWidget {
  final Map<String, dynamic> item;

  StaffCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(7),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          title: Text(item['name']),
          trailing: ElevatedButton(
            onPressed: () {
              

              showAdaptiveDialog(
                  context: context,
                  builder: (context) {
                    return Container(
                        child: AlertDialog(
                      title: Text(item['name']+'\nWork Ststus & Monthly  Report'),
                      // backgroundColor: Colors.white,
                      actions: [
                        Container(
                          // color: Colors.red,
                          // height: 200,
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Details_admin_web(
                                                name: item['name'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text('Status')),
                                    
                                    Expanded(child: Container()),

                                    ElevatedButton(
                                        onPressed: () {
                                          // print('yes');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Report_Retrive(
                                                id: item['user_name'],
                                                name: item['name'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text('Report'))
                                  ]),
                            ],
                          ),
                        ),
                      ],
                    ));
                  },
                );
            },
            child: Text('Show Status'),
          ),
        ),
      ),
    );
  }
}