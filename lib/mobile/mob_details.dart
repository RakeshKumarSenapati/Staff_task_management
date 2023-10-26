import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Task_details extends StatefulWidget {
  Task_details({Key? key}) : super(key: key);

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<Task_details> {
  List<dynamic> data = [];
  String course = '';
  String year = '';

  Future<void> fetchData() async {
    var url = Uri.parse('https://creativecollege.in/Flutter/Task_Details.php');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      Fluttertoast.showToast(
        msg: 'No Task Found',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
  }

  Future<void> Conditionfetch(String data) async {
    var url = Uri.parse('Task_Condition.php?data=$data');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      Fluttertoast.showToast(
        msg: 'No Task Found',
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
      body: Column(
        children: [
         Container(
            margin: EdgeInsets.only(top: 10,bottom: 10,left: 30,right: 30), // Adjust the margin as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Center the buttons horizontally
              children: [
                OutlinedButton(
                    onPressed: () {
                      Conditionfetch("Not Started");
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    child: Text('Not Start',style: TextStyle(color: Colors.black)),
                  ),
                OutlinedButton(
                    onPressed: () {
                        Conditionfetch("Started");
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child: Text('Pending',style: TextStyle(color: Colors.black)),
                  ),
                OutlinedButton(
                    onPressed: () {
                      Conditionfetch("Completed");
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    child: Text('Completed',style: TextStyle(color: Colors.black)),
                  ),
              ],
            ),
          ),


          Container(
            margin: EdgeInsets.only(top: 10,bottom: 10,left: 30,right: 30), // Adjust the margin as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Center the buttons horizontally
              children: [
                Text("TITLE",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold )),
                Text("STATUS",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold ),),
              ],
            ),
          ),
           Divider( // Add a horizontal line here
      color: Colors.black, // Set the color of the line
      thickness: 1.0, // Set the thickness of the line
    ),
          Expanded(
            child: ListView.builder(
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
                            Container(
                              width: 180,
                              child: Text(
                              '${data[index]['TITLE']}',
                              
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            )
                          ],
                        ),
                        
                        if (isNotStarted)
                          Container(
                            height: 15.0,
                            width: 15.0,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(7.5),
                            ),
                          )
                        else if (isNoStarted)
                          Container(
                            height: 15.0,
                            width: 15.0,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(7.5),
                            ),
                          )
                        else if (isNStarted)
                          Container(
                            height: 15.0,
                            width: 15.0,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(7.5),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
