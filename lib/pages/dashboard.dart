import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../consts.dart';




class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    

    int index =2 ;

    final items = <Widget>[
      Icon(Icons.add_task_sharp, size: 30,),
      Icon(Icons.task, size: 30,),
      Icon(Icons.dashboard, size: 30,),
      Icon(Icons.list_alt_rounded, size: 30,),
      Icon(Icons.qr_code_scanner_sharp, size: 30,),

    ];

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Text("HI ! Rakesh ", style: TextStyle(fontSize: 26, color: Colors.white),),
                  Container(child: Icon(Icons.account_circle_rounded,size: 50, color: Colors.white,),margin: EdgeInsets.fromLTRB(150, 5, 0, 0),),
                ],
              ),margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
            ),
          ],
          
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [g1, g2]),
        ),
      ),
      
      bottomNavigationBar:  CurvedNavigationBar(
          height: 60,
          index: index,
          items: items,
          backgroundColor: Color.fromARGB(255, 130, 170, 222),
          ),
          
      );
  }
}