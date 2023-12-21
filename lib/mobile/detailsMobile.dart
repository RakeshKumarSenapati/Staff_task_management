import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/mobile/mob_Profile.dart';
import 'package:flutter_application_1/mobile/mob_add_task.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailsMobile extends StatefulWidget {
  @override
  _DetailsMobileState createState() => _DetailsMobileState();
}

class _DetailsMobileState extends State<DetailsMobile> {
  List<Task> tasks = [];
  late List<Task> originalTasks = [];
  TaskStatus filter = TaskStatus.all;
  DateTime selectedDate = DateTime.now();
  DateTime lastWeek = DateTime.now().subtract(const Duration(days: 7));
  DateTime? selectedMonth;
  int selectedFilterIndex = 0;
  XFile? _pickedImage;
  late String pickedImagePath;

  Future<void> loadImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedImagePath = prefs.getString('pickedImagePath');

    setState(() {
      if (savedImagePath != null) {
        _pickedImage = XFile(savedImagePath);
      }
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // data fetching method call
    initializeData();
    loadImagePath();
  }

  String name = '';
  String designation = '';

  Future<void> initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? '';
    final response = await http.get(
        Uri.parse('https://creativecollege.in/Flutter/Profile.php?id=$userID'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData is List && jsonData.isNotEmpty) {
        final firstElement = jsonData[0];
        setState(() {
          name = firstElement['name'];
        });
      } else {
        setState(() {
          name = 'Data not found';
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
    await fetchData();
    filterTasksToday();
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
      lastWeek = DateTime.now().subtract(const Duration(days: 7));
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

  void _navigateToAddTaskScreen(BuildContext context) {
    // Replace AddTaskScreen with the actual screen you want to navigate to
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Mob_Add_Task()),
    );
  }

  Widget buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FadeInLeftBig(
          duration: const Duration(milliseconds: 1500),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildFilterOption(" Today ", 0, () => filterTasksToday()),
              buildFilterOption(" This Week ", 1, () => filterTasksLastWeek()),
              buildFilterOption(" This Month ", 2, () {
                _selectMonth(context);
              }),
              buildFilterOption(" This Year ", 3, () {
                _selectYear(context);
              }),
              buildFilterOption(" All ", 4, () => setFilter(TaskStatus.all)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFilterOption(String label, int index, VoidCallback onPressed) {
    const _color1 = Color(0xFFC21E56);
    const _color2 = Color(0xFFF09FDE);
    final isSelected = selectedFilterIndex == index;
    final bgColor = isSelected ? _color1 : _color2;

    return Card(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(color: _color1),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedFilterIndex = index;
          });
          onPressed();
        },
        borderRadius: BorderRadius.circular(20.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    const _color1 = Color(0xFFC21E56);
    const _color2 = Color(0xFFF09FDE);

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 1500),
              child: ClipPath(
                clipper: AppBarClipper(),
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: const BoxDecoration(
                    color: _color1,
                  ),
                  child: Row(
                    children: [
                      const Column(
                        children: [
                          SizedBox(height: 30),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 45),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Profile(),
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: _pickedImage == null
                                          ? const AssetImage(
                                              'assets/images/technocart.png')
                                          : FileImage(File(_pickedImage!.path))
                                              as ImageProvider<Object>?,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Hi!",
                                        style: TextStyle(
                                          fontSize: 28,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40, left: 16),
                            child: Builder(
                              builder: (context) => IconButton(
                                icon: const Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                ),
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
            const SizedBox(
              height: 10,
            ),
            // Check if tasks list is empty
            tasks.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        Icon(
                          Icons.add_task_rounded,
                          size: 40,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "There is nothing scheduled",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Try adding new activities",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: tasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        final task = tasks.reversed.toList()[index];

                        if (filter != TaskStatus.all && task.status != filter) {
                          return Container();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: FadeInRightBig(
                            duration: Duration(milliseconds: 800),
                            delay: Duration(milliseconds: index * 50),
                            child: Card(
                              child: SizedBox(
                                height: 93,
                                child: Center(
                                  child: ListTile(
                                    leading: TaskStatusIcon(task.status),
                                    title: Flexible(
                                        child: Text(
                                      task.name,
                                      style: TextStyle(fontSize: 13),
                                    )),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("start : " + task.startDate),
                                        Text("complete : " + task.endDate),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              elevation: 1,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      endDrawer: Drawer(
        width: 300,
        child: ListView(
          children: [
            ListTile(
              title: const Text("All"),
              selected: filter == TaskStatus.all,
              onTap: () {
                setFilter(TaskStatus.all);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Active"),
              selected: filter == TaskStatus.active,
              onTap: () {
                setFilter(TaskStatus.active);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Pending"),
              selected: filter == TaskStatus.pending,
              onTap: () {
                setFilter(TaskStatus.pending);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Completed"),
              selected: filter == TaskStatus.completed,
              onTap: () {
                setFilter(TaskStatus.completed);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: _color1),
            borderRadius: const BorderRadius.all(Radius.circular(18))),
        child: FloatingActionButton(
          backgroundColor: _color2,
          onPressed: () {
            _navigateToAddTaskScreen(context);
          },
          child: const Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
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
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          taskStatus.toString().split('.').last.toUpperCase(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
