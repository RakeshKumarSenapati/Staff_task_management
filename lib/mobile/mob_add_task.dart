import 'package:flutter/material.dart';

class Mob_Add_Task extends StatefulWidget {
  const Mob_Add_Task({super.key});

  @override
  State<Mob_Add_Task> createState() => _Mob_Add_TaskState();
}

class _Mob_Add_TaskState extends State<Mob_Add_Task> {
  @override
  Widget build(BuildContext context) {
    var name = "Name";
    var desg = "developer";
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
                child: Text(
              "ADD WORKS",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            )),
            /* ListTile(
                  leading: 
                     Container(
                      width: 100,
                      height: 200,
                                           child: CircleAvatar(
                        
                        backgroundColor:Colors.green,
                        // backgroundImage: AssetImage("assets/images/user.jpeg"),
                        
                                       ),
                     ),
                
                  title:Text("Hello user") ,
      
                ),*/
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      backgroundImage: AssetImage("assets/images/user2.jpg"),
                      radius: 40,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "Hello  ",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          name,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          desg,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 12, right: 12),
              child: Container(
                  width: 400,
                  child: Column(
                    children: [
                      Text(
                        "Title Of Work:-",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            hintText: "Enter The  work",
                            // enabled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(232, 95, 1, 105),
                                    width: 2)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black, width: 1.5)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      )
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, right: 12, left: 12),
              child: Container(
                  width: 400,
                  child: Column(
                    children: [
                      Text(
                        "Description Of Work:-",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                      SingleChildScrollView(
                        child: TextFormField(
                          maxLines: null,
                          decoration: InputDecoration(
                              hintText: "Enter The description of work",
                              contentPadding: EdgeInsets.only(
                                  top: 0.0,
                                  bottom: 110.0,
                                  left: 20.0,
                                  right: 23.0),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(232, 95, 1, 105),
                                      width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.5)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 23),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Add",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          elevation: MaterialStateProperty.all<double>(5.0),
                          shadowColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          minimumSize: MaterialStateProperty.all<Size>(
                              Size(100.0, 50.0)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                                side:
                                    BorderSide(color: Colors.black, width: 2)),
                          ),
                          overlayColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 51, 24, 148))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 23),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Delete",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w900),
                      ),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          elevation: MaterialStateProperty.all<double>(5.0),
                          shadowColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          minimumSize: MaterialStateProperty.all<Size>(
                              Size(100.0, 50.0)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                                side:
                                    BorderSide(color: Colors.black, width: 2)),
                          ),
                          overlayColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 51, 24, 148))),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 23),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Task description",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        child: Text(
                      "more->",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue),
                    )),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                margin: EdgeInsets.only(top: 5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 180,
                        height: 150,
                        child: Card(
                            elevation: 11,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Title ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                  "Description",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            )),
                      ),
                      Container(
                        width: 180,
                        height: 150,
                        margin: EdgeInsets.only(left: 20),
                        child: Card(
                            elevation: 5,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Title",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                  "Description",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    )
        /* Container(
          width: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(232, 95, 1, 105), width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black, width: 1.5)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              TextField(
                decoration: InputDecoration(
                  
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              )
            ],
          ),
          
        ),*/
        );
  }
}