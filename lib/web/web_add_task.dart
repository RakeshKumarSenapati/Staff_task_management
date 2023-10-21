import 'package:flutter/material.dart';

class Web_Add_TAsk extends StatefulWidget {
  const Web_Add_TAsk({super.key});

  @override
  State<Web_Add_TAsk> createState() => _Web_Add_TAskState();
}

class _Web_Add_TAskState extends State<Web_Add_TAsk> {
  @override
  Widget build(BuildContext context) {
    var name = "Name";
    var desg = "developer";
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /*Center(
                child: Text(
              "ADD WORKS",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            )),*/
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
                  margin: const EdgeInsets.only(left: 10),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      // backgroundColor: Colors.blue,
                      backgroundImage: AssetImage("assets/images/user2.jpg"),
                      radius: 40,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          "Hello  ",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          desg,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ))
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Container(
                      // color: Colors.amber,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: SingleChildScrollView(
                            child: Container(
                                width: 400,
                                child: Column(
                                  children: [
                                    const Text(
                                      "Title Of Work:-",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                          hintText: "Enter The  work",
                                          // enabled: true,
                                          focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      232, 95, 1, 105),
                                                  width: 2)),
                                          enabledBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 1.5)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                    )
                                  ],
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 40, right: 12, left: 12),
                          child: Container(
                              width: 400,
                              child: Column(
                                children: [
                                  const Text(
                                    "Description Of Work:-",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SingleChildScrollView(
                                    child: TextFormField(
                                      maxLines: null,
                                      decoration: InputDecoration(
                                          hintText:
                                              "Enter The description of work",
                                          contentPadding: const EdgeInsets.only(
                                              top: 0.0,
                                              bottom: 110.0,
                                              left: 20.0,
                                              right: 23.0),
                                          focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      232, 95, 1, 105),
                                                  width: 2)),
                                          enabledBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 1.5)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
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
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue),
                                      elevation:
                                          MaterialStateProperty.all<double>(
                                              5.0),
                                      shadowColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                      minimumSize:
                                          MaterialStateProperty.all<Size>(
                                              const Size(100.0, 50.0)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            side: const BorderSide(
                                                color: Colors.black, width: 2)),
                                      ),
                                      overlayColor: MaterialStateProperty.all(
                                          const Color.fromARGB(255, 51, 24, 148))),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 23),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue),
                                      elevation:
                                          MaterialStateProperty.all<double>(
                                              5.0),
                                      shadowColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                      minimumSize:
                                          MaterialStateProperty.all<Size>(
                                              const Size(100.0, 50.0)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            side: const BorderSide(
                                                color: Colors.black, width: 2)),
                                      ),
                                      overlayColor: MaterialStateProperty.all(
                                          const Color.fromARGB(255, 51, 24, 148))),
                                ),
                              )
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.only(top: 130, left: 150),
                      width: 800,
                      height: 500,
                      // color: Colors.amber,
                      child: Column(
                        children: [
                          Container(
                            width: 800,
                            height: 300,
                            // color: Colors.amber,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Card(
                                      elevation: 5,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
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
                                );
                              },
                              itemCount: 10,
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.only(left: 700),
                              child: const InkWell(
                                child: Text(
                                  "more->",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.blue),
                                ),
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            /* Container(
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
          */
          ],
        ),
      ),
    ));
  }
}
