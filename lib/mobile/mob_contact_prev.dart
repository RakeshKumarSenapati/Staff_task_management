import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final BorderRadiusGeometry borderRadius;

  const CustomAppBar({required this.title, required this.borderRadius});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: const Color(0xFFC21E56),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
    );
  }
}

class ContactPrev extends StatefulWidget {
  const ContactPrev({Key? key}) : super(key: key);

  @override
  State<ContactPrev> createState() => _ContactPage();
}

class _ContactPage extends State<ContactPrev> {
  List<String> allowedCourses = ['BSC', 'BCA', 'BBA'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'SELECT COURSE',
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                for (String course in allowedCourses)
                  CardItem(course, const Color(0xFFC21E56)),
              ],
            ),
          ),
        ),
      ),
    );
  }

 // ignore: non_constant_identifier_names
 Widget CardItem(String course, Color cardColor) {
  return Card(
    color: cardColor,
    margin: const EdgeInsets.only(top: 16),
    child: InkWell(
      onTap: () {
        _navigateToContactPage(course);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center( // Center the text within the button
          child: Text(
            course,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}


  void _navigateToContactPage(String course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Contact(course: course, year: ''),
      ),
    );
  }
}

class Contact extends StatefulWidget {
  final String course;
  final String year;

  Contact({Key? key, required this.course, required this.year})
      : super(key: key);

  @override
  _Contact createState() => _Contact();
}

class _Contact extends State<Contact> {
  int? expandedIndex;
  String selectedYear = '1st'; 
  directCall(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  List<dynamic> data = [];
  String Course = '';
  String Year = '';
  bool isExpanded = false;

  Future<void> fetchDataForYear() async {
    Course = widget.course;
    Year = selectedYear; // Use the selected year
    var url = Uri.parse(
        'https://creativecollege.in/Flutter/StudentContact.php?Course=$Course&Year=$Year');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      print('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataForYear();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    String telScheme = 'tel:$phoneNumber';
    if (await canLaunch(telScheme)) {
      await launch(telScheme);
    } else {
      throw 'Could not launch $telScheme';
    }
  }

  Widget _buildYearButton(String label, String year) {
    Color customColor = Color(0xFFC21E56);
    Color innerColor = Color(0xFFF09FDE);

    return Container(
      child: ElevatedButton(
        onPressed: () {
          selectedYear = year; // Update the selected year
          fetchDataForYear();
        },
        style: ElevatedButton.styleFrom(
          primary: innerColor,
          onPrimary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: customColor),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.center, // Center the text
            child: Text(
              label,
              style:
                  const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.course}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFC21E56),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(80.0),
            bottomRight: Radius.circular(80.0),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(data: data),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(16.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildYearButton('1st Year', '1st'),
              _buildYearButton('2nd Year', '2nd'),
              _buildYearButton('3rd Year', '3rd'),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('ID: ${data[index]['ID']}',
                                          style: TextStyle(fontSize: 18)),
                                      Text('Name: ${data[index]['NAME']}',
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isExpanded
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      expandedIndex = (expandedIndex == index)
                                          ? null
                                          : index;
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (expandedIndex == index)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          'Student No: ${data[index]['MOB_NO']}',
                                          style: TextStyle(fontSize: 18)),
                                      IconButton(
                                        icon: Icon(Icons.call),
                                        onPressed: () {
                                          String num = data[index]['MOB_NO'];
                                          directCall(num);
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Father No: ${data[index]['F_MOB']}',
                                          style: TextStyle(fontSize: 18)),
                                      IconButton(
                                        icon: Icon(Icons.call),
                                        onPressed: () {
                                          String num = data[index]['F_MOB'];
                                          directCall(num);
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Mother No: ${data[index]['M_MOB']}',
                                          style: TextStyle(fontSize: 18)),
                                      IconButton(
                                        icon: Icon(Icons.call),
                                        onPressed: () {
                                          String num = data[index]['M_MOB'];
                                          directCall(num);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
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

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<dynamic> data;

  CustomSearchDelegate({required this.data});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<dynamic> searchResults = data
        .where((item) =>
            item['ID'].toString().contains(query) ||
            item['NAME'].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (searchResults.isEmpty) {
      return Center(
        child: Text('No results found for: $query'),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(16.0),
          child: Card(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID: ${searchResults[index]['ID']}',
                                  style: TextStyle(fontSize: 18)),
                              Text('Name: ${searchResults[index]['NAME']}',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            size: 30,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                                'Student No: ${searchResults[index]['MOB_NO']}',
                                style: TextStyle(fontSize: 18)),
                            IconButton(
                              icon: Icon(Icons.call),
                              onPressed: () {
                                String num = searchResults[index]['MOB_NO'];
                                // Add your phone call functionality here
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Father No: ${searchResults[index]['F_MOB']}',
                                style: TextStyle(fontSize: 18)),
                            IconButton(
                              icon: Icon(Icons.call),
                              onPressed: () {
                                String num = searchResults[index]['F_MOB'];
                                // Add your phone call functionality here
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Mother No: ${searchResults[index]['M_MOB']}',
                                style: TextStyle(fontSize: 18)),
                            IconButton(
                              icon: Icon(Icons.call),
                              onPressed: () {
                                String num = searchResults[index]['M_MOB'];
                                // Add your phone call functionality here
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<dynamic> suggestionResults = data
        .where((item) =>
            item['ID'].toString().contains(query) ||
            item['NAME'].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (suggestionResults.isEmpty) {
      return Center(
        child: Text('No suggestions for: $query'),
      );
    }

    return ListView.builder(
      itemCount: suggestionResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            'ID: ${suggestionResults[index]['ID']} - Name: ${suggestionResults[index]['NAME']}',
          ),
          onTap: () {
            query = suggestionResults[index]['ID'].toString();
            showResults(context);
          },
        );
      },
    );
  }
}
