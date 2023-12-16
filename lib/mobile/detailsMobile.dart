import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailsMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  late List<Task> originalTasks = [];
  TaskStatus filter = TaskStatus.all;
  DateTime selectedDate = DateTime.now();
  DateTime lastWeek = DateTime.now().subtract(Duration(days: 7));
  DateTime? selectedMonth;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // data fetching method call
    fetchData();
  }

  // status convert
  TaskStatus taskStatusFromString(String status) {
    switch (status) {
      case 'Started':
        return TaskStatus.active;
      case 'Completed':
        return TaskStatus.completed;
      case 'Not Started':
        return TaskStatus.pending;
      default:
        return TaskStatus.all;
    }
  }

// data fetching from api
  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? '';
    final response = await http.get(Uri.parse(
        'https://creativecollege.in/Flutter/Task_Details.php?id=$userID'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        tasks = responseData.map((taskData) {
          return Task(
              taskData['TITLE'],
              taskStatusFromString(taskData['STATUS']),
              taskData['ADDDATE'],
              taskData['STARTDATE'],
              taskData['ENDDATE']);
        }).toList();
        originalTasks = List.from(tasks);
      });
    } else {
      throw Exception('Error while fetching data');
    }
  }

  void setFilter(TaskStatus newFilter) {
    setState(() {
      filter = newFilter;
      if (filter == TaskStatus.all) {
        tasks = List.from(originalTasks);
      }
    });
  }

  void filterTasksByDate(DateTime date) {
    setState(() {
      setFilter(TaskStatus.all);
      filter = TaskStatus.all;
      selectedDate = date;
      tasks = originalTasks.where((task) {
        final taskDate = DateFormat("yyyy-MM-dd").parse(task.date);
        return taskDate.isAtSameMomentAs(date);
      }).toList();
    });
  }

  void filterTasksLastWeek() {
    setState(() {
      setFilter(TaskStatus.all);
      filter = TaskStatus.all;
      lastWeek = DateTime.now().subtract(Duration(days: 7));
      tasks = originalTasks.where((task) {
        final taskDate = DateFormat("yyyy-MM-dd").parse(task.date);
        return taskDate.isAfter(lastWeek) ||
            taskDate.isAtSameMomentAs(lastWeek);
      }).toList();
    });
  }

  void filterTasksToday() {
    setState(() {
      setFilter(TaskStatus.all);
      filter = TaskStatus.all;
      selectedDate = DateTime.now();
      tasks = originalTasks.where((task) {
        final taskDate = DateTime.parse(task.date).toLocal();
        final todayStart = DateTime(selectedDate.year, selectedDate.month,
                selectedDate.day, 0, 0, 0)
            .toLocal();
        final todayEnd = DateTime(selectedDate.year, selectedDate.month,
                selectedDate.day, 23, 59, 59)
            .toLocal();
        return taskDate.isAtSameMomentAs(todayStart) ||
            (taskDate.isAfter(todayStart) && taskDate.isBefore(todayEnd));
      }).toList();
    });
  }

  void filterTasksByYear(int year) {
    setState(() {
      setFilter(TaskStatus.all);
      filter = TaskStatus.all;
      tasks = originalTasks.where((task) {
        final taskDate = DateFormat("yyyy-MM-dd").parse(task.date);
        return taskDate.year == year;
      }).toList();
    });
  }

  void filterTasksByMonth(DateTime? month) {
    if (month == null) {
      return;
    }

    setState(() {
      setFilter(TaskStatus.all);
      filter = TaskStatus.all;
      selectedMonth = month;
      tasks = originalTasks.where((task) {
        final taskDate = DateFormat("yyyy-MM-dd").parse(task.date);
        return taskDate.month == month.month && taskDate.year == month.year;
      }).toList();
    });
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        filterTasksByDate(selectedDate);
      });
    }
  }

  void _selectMonth(BuildContext context) {
    DateTime now = DateTime.now();
    filterTasksByMonth(DateTime(now.year, now.month));
  }

  void _selectYear(BuildContext context) {
    int currentYear = DateTime.now().year;
    filterTasksByYear(currentYear);
  }

  Widget buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FadeInLeftBig(
            duration: Duration(milliseconds: 1500),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildFilterOption(" Today ", () => filterTasksToday()),
                buildFilterOption(" This Week ", () => filterTasksLastWeek()),
                buildFilterOption(" This Month ", () {
                  _selectMonth(context);
                }),
                buildFilterOption(" This Year ", () {
                  _selectYear(context);
                }),
                buildFilterOption(" All ", () => setFilter(TaskStatus.all)),
              ],
            ),
          )),
    );
  }

  Widget buildFilterOption(String label, VoidCallback onPressed) {
    const _color1 = Color(0xFFC21E56);
    const _color2 = Color(0xFFF09FDE);

    return Card(
      color: _color2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: _color1),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
          child: Text(label),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String name = "Activity Manager";
    const _color1 = Color(0xFFC21E56);

    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          FadeInDown(
            duration: Duration(milliseconds: 1500),
            child: ClipPath(
              clipper: AppBarClipper(),
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: _color1,
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.all(0),
                          // child: Icon(
                          //   Icons.person,
                          //   color: Colors.black,
                          //   size: 75,
                          // ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 65),
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 40, left: 16), // Adjust left padding
                          child: Builder(
                            builder: (context) => IconButton(
                              icon: Icon(Icons.menu),
                              iconSize: 35,
                              onPressed: () {
                                Scaffold.of(context).openEndDrawer();
                              },
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
          buildFilterOptions(),
          SizedBox(
            height: 10,
          ),
          Container(
              height: 400,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  final task = tasks.reversed.toList()[index];

                  if (filter != TaskStatus.all && task.status != filter) {
                    return Container();
                  }

                  String dateToShow = '';

                  if (task.status == TaskStatus.completed) {
                    dateToShow = task.endDate;
                  } else if (task.status == TaskStatus.active) {
                    dateToShow = task.startDate;
                  } else if (task.status == TaskStatus.pending) {
                    dateToShow = task.date;
                  }

                  return Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: FadeInRightBig(
                      duration: Duration(milliseconds: 1500),
                      delay: Duration(milliseconds: index * 200),
                      child: Card(
                        child: SizedBox(
                          height: 70,
                          child: Center(
                            child: ListTile(
                              leading: TaskStatusIcon(task.status),
                              title: Text(task.name),
                              trailing: Text(dateToShow),
                            ),
                          ),
                        ),
                        elevation: 1,
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
      endDrawer: Drawer(
          width: 300,
          child: ListView(
            children: [
              ListTile(
                  title: Text("All"),
                  selected: filter == TaskStatus.all,
                  onTap: () {
                    setFilter(TaskStatus.all);
                    Navigator.pop(context);
                  }),
              ListTile(
                title: Text("Active"),
                selected: filter == TaskStatus.active,
                onTap: () {
                  setFilter(TaskStatus.active);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Pending"),
                selected: filter == TaskStatus.pending,
                onTap: () {
                  setFilter(TaskStatus.pending);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Completed"),
                selected: filter == TaskStatus.completed,
                onTap: () {
                  setFilter(TaskStatus.completed);
                  Navigator.pop(context);
                },
              ),
            ],
          )),
    );
  }
}

class AppBarClipper extends CustomClipper<Path> {
  final double controlPointPercentage;

  AppBarClipper({this.controlPointPercentage = 0.5});

  @override
  Path getClip(Size size) {
    var path = Path();

    final p0 = size.height * 0.75;
    path.lineTo(0, p0);

    final controlPoint =
        Offset(size.width * controlPointPercentage, size.height);
    final endPoint = Offset(
        size.width, size.width < 600 ? size.height / 1.5 : size.height / 2);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) =>
      oldClipper != this;
}

enum TaskStatus { active, completed, pending, all }

class Task {
  final String name;
  final TaskStatus status;
  final String date;
  final String startDate;
  final String endDate;

  Task(this.name, this.status, this.date, this.startDate, this.endDate);
}

class TaskStatusIcon extends StatelessWidget {
  final TaskStatus status;

  TaskStatusIcon(this.status);

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color color;
    switch (status) {
      case TaskStatus.active:
        iconData = Icons.circle;
        color = Colors.green;
        break;
      case TaskStatus.completed:
        iconData = Icons.check_circle;
        color = Colors.green;
        break;
      case TaskStatus.pending:
        iconData = Icons.circle;
        color = Colors.red;
        break;
      default:
        iconData = Icons.circle;
        color = Colors.grey;
    }
    return Icon(iconData, color: color);
  }
}

class TaskCount extends StatelessWidget {
  final TaskStatus taskStatus;
  final List<Task> tasks;

  TaskCount({required this.taskStatus, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final count = tasks.where((task) => task.status == taskStatus).length;

    return Column(
      children: [
        TaskStatusIcon(taskStatus),
        Text(
          '$count',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          taskStatus.toString().split('.').last.toUpperCase(),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
