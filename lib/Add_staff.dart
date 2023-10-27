import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class StaffAdd extends StatefulWidget {
  const StaffAdd({super.key});

  @override
  State<StaffAdd> createState() => _StaffAddState();
}

class _StaffAddState extends State<StaffAdd> {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController passController = TextEditingController();
    final TextEditingController desigController = TextEditingController();

    final _formKey = GlobalKey<FormState>();
  void signUp() async {
    final response = await http.post(
      Uri.parse('https://creativecollege.in/Flutter/staff_add.php'),
      body: {
        'name': nameController.text,
        'desig':desigController.text,
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
        nameController.text='';
        desigController.text='';
        passController.text='';
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
        title: Text('Add Staff'),
        backgroundColor: Color.fromARGB(255, 255, 124, 1)
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                
                ),
                TextFormField(
                  controller: desigController,
                  decoration: InputDecoration(labelText: 'Designation'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter your designation';
                    }
                    return null;
                  },
                  
                ),
                TextFormField(
                  controller: passController,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                 
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        if(nameController.text==''){
                          Fluttertoast.showToast(
                            msg: 'Name Is Empty',
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                          );
                        }
                        else if(desigController.text=='')
                        {
                          Fluttertoast.showToast(
                            msg: 'Designation Is Empty',
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                          );
                        }
                        else if(passController.text=='')
                        {
                          Fluttertoast.showToast(
                            msg: 'Password Is Empty',
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                          );
                        }
                        else{
                          signUp();
                        }
                      },
                      child: Text('Submit'),
                    ),
                    ElevatedButton(
                      onPressed: _clearForm,
                      child: Text('Clear'),
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
  }
}