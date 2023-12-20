import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Admin_Leave_Page extends StatefulWidget {
  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<Admin_Leave_Page> {
  TextEditingController reason = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  List<dynamic> data = [];

  Future<void> fetchData() async {
    var url = Uri.parse('https://creativecollege.in/Flutter/Leave_Data.php');

    var response = await http.get(url);

    if (response.statusCode == 200) {


      setState(() {
        data = json.decode(response.body);
      });

      if (data.isEmpty) {
        Fluttertoast.showToast(
          msg: 'No Leave Found for userID',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Error fetching data',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

   Future<void> _Delete(String Reason,String Startdate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? '';
    final response = await http.post(
      Uri.parse('https://creativecollege.in/Flutter/Delete_Leave.php'),
      body: {
        'ID': userID.trim(),
        'reason': Reason,
        'startdate': Startdate,
      },
    );

    Fluttertoast.showToast(
      msg: response.body,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    reason.text = '';
  }


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    const _color1 = Color(0xFFC21E56);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _color1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                   
                  ],
                )),
          ),
        ],
        title: Text(
          'Leave Request' ,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      
      backgroundColor: Colors.white,
      body: ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              'Reason: ${data[index]['Reason']}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Start Date: ${data[index]['Start_Date']}'),
                Text('Last Date: ${data[index]['Last_Date']}'),
                Text('Status: ${data[index]['Status']}'), // Corrected key name
              ],
            ),
            trailing: GestureDetector(
              onTap: () {
                String reason = data[index]['Reason'];
                String startDate = data[index]['Start_Date'];
                _Delete(reason, startDate).then((value) => {
                  fetchData(),
                });
              },
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
          if (index < data.length - 1) Divider(),
        ],
      );
    },
  ),
);
  }
}
