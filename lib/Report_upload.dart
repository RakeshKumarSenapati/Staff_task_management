import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/mobile/pdfView.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Report_upload extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report_upload> {
  File? _selectedFile;
  bool _isLoading = false;
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<List<dynamic>> fetchData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userID = prefs.getString('userID');

  if (userID == null) {
    throw Exception('UserID not found in SharedPreferences');
  }

  var url = Uri.parse('https://creativecollege.in/Flutter/Retrive_Report.php');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    List<dynamic> allItems = json.decode(response.body);

    List<dynamic> filteredItems = allItems.where((item) => item['ID'] == userID).toList();
    setState(() {
      items=filteredItems;
    });
    
    return filteredItems;
  } else {
    throw Exception('Failed to load data');
  }
}


 
  Future<void> _uploadFile() async {
    setState(() {
      _isLoading = true;
    });

    if (_selectedFile != null) {
      String fileExtension = _selectedFile!.path.split('.').last.toLowerCase();

      if (fileExtension == 'pdf') {
        // await uploadFile(_selectedFile!);
      } else {
        _showToast('Unsupported file format. Please select a PDF file.', Colors.red);
      }
    } else {
      _showToast('No file selected', Colors.red);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    const _color1 = Color(0xFFC21E56);
    var _selectFile;
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Reports',
        style: TextStyle(color: Colors.white),
        ),
        backgroundColor: _color1,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _isLoading
                ? CircularProgressIndicator()
                : FileUploader(
                    selectedFile: _selectedFile,
                     onSelectFile: _selectFile,
                    onUploadFile: _uploadFile,
                  ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 3,
                    shadowColor: _color1,
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(items[index]['Filename'].toString()),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Uploaded : ${items[index]['Month']} ${items[index]['Year']}'),
                         
                        ],
                      ),
                      onTap: () {
                        String name = items[index]['Filename'].toString();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFViewer(
                              url: "https://creativecollege.in/Flutter/Report/Pdflist.php?name=$name",
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FileUploader extends StatelessWidget {
  final File? selectedFile;
  final VoidCallback onSelectFile;
  final VoidCallback onUploadFile;

  List<dynamic> items = [];
  
  Future<void> fetchData() async {
    var url =
        Uri.parse('https://creativecollege.in/Flutter/Retrive_Report.php');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      
        items = json.decode(response.body);
    } else {
      print('Failed to load data');
    }
  }


   FileUploader({
    Key? key,
    required this.selectedFile,
    required this.onSelectFile,
    required this.onUploadFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _color1 = Color(0xFFC21E56);
    return Column(
      children: [
         Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(width: 1,
        color: _color1,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: _color1, //Colors.grey.withOpacity(0.5),
            // spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (selectedFile != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '     ${selectedFile!.path.split('/').last}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ElevatedButton.icon(
            onPressed: onSelectFile,
            icon: Icon(Icons.attach_file,
            color: Colors.white,),
            label: Text('Select File',
            style: TextStyle(
              color: Colors.white
            ),),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: onUploadFile,
            icon: Icon(Icons.cloud_upload,
            color: Colors.white,),
            label: Text('Upload File',
            style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
          ),
        ],
      ),
    )
    
      ]
    );
  }
}

