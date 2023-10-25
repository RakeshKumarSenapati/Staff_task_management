import 'package:flutter/material.dart';

class StaffAdd extends StatefulWidget {
  const StaffAdd({super.key});

  @override
  State<StaffAdd> createState() => _StaffAddState();
}

class _StaffAddState extends State<StaffAdd> {

    final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String desig = '';
  String pass = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, do something with the data
      print('Name: $name');
      print('Email: $email');
    }
  }

  void _clearForm() {
    // setState(() {
    //   name = '';
    //   email = '';
    //   desig = '';
    //   pass = '';
    // });

  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Staff'),
        backgroundColor: Color.fromARGB(255, 255, 124, 1)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Designation'),
                validator: (value) {
                  if (value == null) {
                    return 'Please enter your designation';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    desig = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    pass = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
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
    );
  }
}