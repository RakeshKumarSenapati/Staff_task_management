import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';

class StaffAdd extends StatefulWidget {
  const StaffAdd({Key? key}) : super(key: key);

  @override
  State<StaffAdd> createState() => _StaffAddState();
}

class _StaffAddState extends State<StaffAdd> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController desigController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void Add_Staff() async {
    final response = await http.post(
      Uri.parse('https://creativecollege.in/Flutter/staff_add.php'),
      body: {
        'name': nameController.text,
        'desig': desigController.text,
        'password': passController.text,
      },
    );

    if (response.statusCode == 200) {
      if (response.body == 'Success') {
        Fluttertoast.showToast(
          msg: 'NEW STAFF ADDED',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        nameController.text = '';
        desigController.text = '';
        passController.text = '';
      } else {
        Fluttertoast.showToast(
          msg: response.body,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 175, 76, 76),
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Staff',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                FadeInUp(
                  duration: Duration(milliseconds: 1000),
                  delay: Duration(milliseconds: 50),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                FadeInUp(
                  duration: Duration(milliseconds: 1000),
                  delay: Duration(milliseconds: 50),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: desigController,
                      decoration: InputDecoration(
                        labelText: 'Designation',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your designation';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                FadeInUp(
                  duration: Duration(milliseconds: 1000),
                  delay: Duration(milliseconds: 50),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: passController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FadeInLeftBig(
                      duration: Duration(milliseconds: 1000),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor:
                                      Colors.white, // Set background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ), // Set rounded corner
                                  title: Text(
                                    "Confirm",
                                    style: TextStyle(
                                      color:
                                          Colors.black, // Set title text color
                                    ),
                                  ),
                                  content: Text(
                                    "Are you sure you want to add this staff?",
                                    style: TextStyle(
                                      color: Colors
                                          .black, // Set content text color
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors
                                              .blue, // Set cancel button text color
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Perform staff addition operation
                                        Add_Staff();
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text(
                                        "Confirm",
                                        style: TextStyle(
                                          color: Colors
                                              .red, // Set confirm button text color
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green, // Background color
                          onPrimary: Colors.white, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Rounded corner radius
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24), // Button padding
                        ),
                        child: Text(
                          'Add Staff',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    FadeInRightBig(
                      duration: Duration(milliseconds: 1000),
                      child: ElevatedButton(
                        onPressed: _clearForm,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // Background color
                          onPrimary: Colors.white, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Rounded corner radius
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24), // Button padding
                        ),
                        child: Text(
                          "Clear Fields",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _clearForm() {
    nameController.text = '';
    desigController.text = '';
    passController.text = '';
  }
}
