import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Task_mgmt extends StatefulWidget {

  Task_mgmt({Key? key}) : super(key: key);

  @override
  _Task_mgmt createState() => _Task_mgmt();
}

class _Task_mgmt extends State<Task_mgmt> {
  List<dynamic> data = [];
  String Course = ''; 
  String Year = ''; 

  Future<void> fetchData() async {
    
   var url = Uri.parse('https://creativecollege.in/Flutter/Task_mgmt.php');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      }
      );
    } else {
      print('Failed to load data');
    }
  }

  Future<void> STARTIT(String Status,String title) async {
    final response = await http.post(
      Uri.parse('https://creativecollege.in/Flutter/Task_operation.php'),
      body: {
        'STATUS': Status,
        'TITLE': title,
      },
    );

      if (response.body == 'Success') {

        Fluttertoast.showToast(
        msg: 'UPDATED',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      } else {

        Fluttertoast.showToast(
        msg: 'UPDATE FAILED',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
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
      title: Text('TASK'),
    ),
    body: ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        String status = data[index]['STATUS'];
        bool isNotStarted = status == 'Not Started';
        bool isNoStarted = status == 'Completed';
        bool isNStarted = status == 'Started';
        return Container(
          margin: const EdgeInsets.only(left: 16.0, top: 5, bottom: 15),
          child: ListTile(
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${data[index]['TITLE']}',
                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${data[index]['DESCRIPTION']}',
                      style: const TextStyle(fontSize: 17),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                if (isNotStarted)
                  ElevatedButton(
                    onPressed: () {
                      String title='${data[index]['TITLE']}';
                      String statuss='Started';
                      STARTIT(statuss,title);
                    },
                    style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Change the background color here
                      ),
                    child: Text(" Get Start "),
                  )
                else if(isNoStarted)
                  ElevatedButton(
                    onPressed: () {
                       String title='${data[index]['TITLE']}';
                       String statuss='Completed';
                      STARTIT(statuss,title);
                    },
                     style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green), // Change the background color here
                      ),
                    child: Text("Completed"),
                  )

                  else if(isNStarted)
                  ElevatedButton(
                    onPressed: () {
                       String title='${data[index]['TITLE']}';
                       String statuss='Completed';
                      STARTIT(statuss,title);
                    },
                     style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 243, 33, 47)), // Change the background color here
                      ),
                    child: Text("Complete"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}