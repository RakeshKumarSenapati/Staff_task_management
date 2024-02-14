import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Contact_Edit extends StatefulWidget {
  final String course;
  final String sem;
  final String id;
  final String sMob;
  final String mMob;
  final String fMob;

  const Contact_Edit({
    Key? key,
    required this.course,
    required this.sem,
    required this.id,
    required this.sMob,
    required this.mMob,
    required this.fMob,
  }) : super(key: key);

  @override
  State<Contact_Edit> createState() => _Mob_Contact_Edit();
}

class _Mob_Contact_Edit extends State<Contact_Edit> {
  TextEditingController user = TextEditingController();
  TextEditingController course = TextEditingController();
  TextEditingController sem = TextEditingController();
  TextEditingController smob = TextEditingController();
  TextEditingController fmob = TextEditingController();
  TextEditingController mmob = TextEditingController();

  @override
  void initState() {
    super.initState();
    user.text = widget.id;
    course.text = widget.course;
    sem.text = widget.sem;
     smob.text = widget.sMob;
    fmob.text = widget.mMob;
    mmob.text = widget.fMob;

  }

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('https://creativecollege.in/Flutter/Contact.php'),
      body: {
        'user': user.text.trim().trim(),
        'course': course.text.trim(),
        'sem': sem.text.trim(),
        'smob': smob.text.trim(),
        'fmob': fmob.text.trim(),
        'mmob': mmob.text.trim(),
      },
    );

      Fluttertoast.showToast(
          msg: response.body,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
    
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 150,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1600),
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Center(
                            child: Text(
                              "Edit Contact",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color.fromRGBO(143, 148, 251, 1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, .2),
                              blurRadius: 20.0,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: user,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Student Id",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                             Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: course,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  label: Text('Enter New Course'),
                                  hintText: "Student Id",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                             Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: sem,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  label: Text('Enter New Semester'),
                                  hintText: "Student Id",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                             Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: smob,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  label: Text('Enter New Number'),
                                  hintText: "Student Id",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                             Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: fmob,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  label: Text('Enter New Father Number'),
                                  hintText: "Student Id",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                // border: Border(
                                //   bottom: BorderSide(
                                //     color: Color.fromRGBO(143, 148, 251, 1),
                                //   ),
                                // ),
                              ),
                              child: TextField(
                              
                                controller: mmob,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  label: Text('Enter New Mother Number'),
                                  hintText: "Course",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                            // ... other text fields
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: InkWell(
                        onTap: () {
                          _login();
                        },
                        child: Container(
                          height: 50,
                          
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Edit Details",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 2000),
                      child: Text(
                        "Designed By Technocrat",
                        style: TextStyle(
                          color: Color.fromRGBO(143, 148, 251, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
