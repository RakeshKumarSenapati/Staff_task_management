import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert'; // For JSON encoding
import 'package:http/http.dart' as http; // For making HTTP requests

class StudentAttendance extends StatelessWidget {
  const StudentAttendance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CourseSelectionPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CourseSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(50.0),
      child: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(10.0),
            ),
            gradient: LinearGradient(
              colors: [Color(0xFFC21E56), Color(0xFF680E35)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Select Course',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCourseButton(context, 'BBA', 'bba'),
          SizedBox(height: 20),
          _buildCourseButton(context, 'BCA', 'bca'),
          SizedBox(height: 20),
          _buildCourseButton(context, 'BSC', 'bsc_cs'),
        ],
      ),
    ),
  );
}

Widget _buildCourseButton(BuildContext context, String title, String course) {
  return ElevatedButton(
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(
            title: title,
            course: course,
          ),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      primary: Colors.blueAccent,
      onPrimary: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    ),
    child: Text(
      title,
      style: TextStyle(fontSize: 20),
    ),
  );
}

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.course})
      : super(key: key);

  final String title;
  final String course;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? selectedDate; // Initial date
  late String selectedYear;
  late String course;

  List<String> roll = [];
  List<String> name = [];
  late List<bool> isContainerVisible;
  late List<bool> isPresentButtonSelected;
  late List<bool> isAbsentButtonSelected;
  Map<String, int> attendanceData = {}; // Map to store attendance data

  @override
  void initState() {
    super.initState();
    selectedYear = '1st';
    isContainerVisible = [];
    isPresentButtonSelected = [];
    isAbsentButtonSelected = [];
    course = widget.course;
    fetchData();
  }

  Future<void> fetchData() async {
    var response = await http.get(Uri.parse(
        'https://creativecollege.in/Flutter/Attendance/retrieve.php?table=${course}_${selectedYear}_attendance'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data is List) {
        List<Map<String, dynamic>> studentDataList =
            List<Map<String, dynamic>>.from(data);

        studentDataList.sort(
            (a, b) => a['name'].toString().compareTo(b['name'].toString()));

        setState(() {
          roll = studentDataList
              .map<String>((student) => student['student_id'].toString())
              .toList();
          name = studentDataList
              .map<String>((student) => student['name'].toString())
              .toList();

          isContainerVisible = List.generate(roll.length, (index) => false);
          isPresentButtonSelected =
              List.generate(roll.length, (index) => false);
          isAbsentButtonSelected = List.generate(roll.length, (index) => false);
        });
      } else {
        print('Invalid data format: data is not a list');
      }
    } else {
      print('Failed to load data: ${response.statusCode}');
    }
  }

  Widget _buildYearButton(String label, String year) {
    Color customColor = const Color(0xFFC21E56);
    Color innerColor = const Color(0xFFF09FDE);
    Color selectedColor = const Color(0xFFC21E56);
    Color textColor = Colors.black;

    if (selectedYear == year) {
      textColor = Colors.white;
    }

    return Container(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedYear = year;
          });
          fetchData();
        },
        style: ElevatedButton.styleFrom(
          primary: selectedYear == year ? selectedColor : innerColor,
          onPrimary: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: customColor),
          ),
          elevation: 5,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void callApiWithSelectedDate() async {
    String formattedDate = DateFormat('dd_MM_yyyy').format(selectedDate!);
    String apiUrl =
        'https://creativecollege.in/Flutter/Attendance/date_column.php?table=${course}_${selectedYear}_attendance&date=$formattedDate';

    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      print('API called successfully with date: $formattedDate');
    } else {
      print('Failed to call API: ${response.statusCode}');
    }
  }

  void submitAttendance() {
    // Check if attendance data is missing for any student
    if (attendanceData.length < roll.length) {
      // Display dialog prompting user to take attendance for all students
      _showAttendanceNotTakenDialog(context);
      return; // Exit function early
    }

    // Call API to submit attendance data
    String formattedDate = DateFormat('dd_MM_yyyy').format(selectedDate!);
    String apiUrl =
        'https://creativecollege.in/Flutter/Attendance/post.php?table=${course}_${selectedYear}_attendance&column_name=${formattedDate}&attendance_data=${jsonEncode(attendanceData)}';

    // Make a GET request
    http.get(Uri.parse(apiUrl)).then((response) {
      if (response.statusCode == 200) {
        print('Attendance submitted successfully');
        // Display dialog indicating successful submission
        _showAttendanceSubmittedDialog(context);
        // Navigate back to course selection page after successful submission
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CourseSelectionPage(),
            ),
          );
        });
      } else {
        print('Failed to submit attendance: ${response.statusCode}');
      }
    }).catchError((error) {
      print('Error submitting attendance: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CourseSelectionPage(),
              ),
            );
          },
        ),
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFC21E56),
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(80.0),
            bottomRight: Radius.circular(80.0),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildYearButton('1st Year', '1st'),
                _buildYearButton('2nd Year', '2nd'),
                _buildYearButton('3rd Year', '3rd'),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _showDatePickerDialog(context);
            },
            child: Card(
              elevation: 5.0,
              margin: EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Date: ${selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : 'Select a date'}",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      height: 90,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name[index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                                      ),
                                    ),
                                    Text(roll[index]),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  OutlinedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        isPresentButtonSelected[index]
                                            ? Colors.green
                                            : Colors.white,
                                      ),
                                      side: MaterialStateProperty.all(
                                        BorderSide(
                                          color: isPresentButtonSelected[index]
                                              ? Colors.white
                                              : Colors.green,
                                        ),
                                      ),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(16.0)),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (selectedDate == null) {
                                        _showDateNotSelectedDialog(context);
                                      } else {
                                        setState(() {
                                          isPresentButtonSelected[index] =
                                              !isPresentButtonSelected[index];
                                          isAbsentButtonSelected[index] =
                                              false;
                                          attendanceData[roll[index]] = 1; // Mark as present
                                        });
                                      }
                                    },
                                    child: Text(
                                      "Present",
                                      style: TextStyle(
                                        color: isPresentButtonSelected[index]
                                            ? Colors.white
                                            : Colors.green,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  OutlinedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        isAbsentButtonSelected[index]
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                      side: MaterialStateProperty.all(
                                        BorderSide(
                                          color: isAbsentButtonSelected[index]
                                              ? Colors.white
                                              : Colors.red,
                                        ),
                                      ),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(16.0)),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (selectedDate == null) {
                                        _showDateNotSelectedDialog(context);
                                      } else {
                                        setState(() {
                                          isAbsentButtonSelected[index] =
                                              !isAbsentButtonSelected[index];
                                          isPresentButtonSelected[index] =
                                              false;
                                          attendanceData[roll[index]] = 0; // Mark as absent
                                        });
                                      }
                                    },
                                    child: Text(
                                      "Absent",
                                      style: TextStyle(
                                        color: isAbsentButtonSelected[index]
                                            ? Colors.white
                                            : Colors.red,
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
                  ],
                );
              },
              itemCount: roll.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                submitAttendance();
              },
              child: Text('Submit Attendance'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDatePickerDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Date'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Theme(
                  data: ThemeData.light().copyWith(
                    primaryColor: const Color(0xFFC21E56),
                    colorScheme: ColorScheme.light(
                      primary: const Color(0xFFC21E56),
                      onPrimary: Colors.black,
                      surface: const Color(0xFFC21E56),
                      onSurface: Colors.black,
                    ),
                    dialogBackgroundColor: Colors.white,
                  ),
                  child: TextButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2025),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });

                        print("Selected date: ${selectedDate}");
                        callApiWithSelectedDate();
                      }

                      Navigator.of(context).pop(); 
                    },
                    style: TextButton.styleFrom(
                      primary: const Color(0xFFC21E56), 
                    ),
                    child: Text('Pick a date'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDateNotSelectedDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please select a date first'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAttendanceNotTakenDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Attendance Not Taken'),
          content: Text('Please take attendance for all students.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAttendanceSubmittedDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Attendance Submitted Successfully'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
