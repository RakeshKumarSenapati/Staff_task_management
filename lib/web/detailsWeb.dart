import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailsWeb extends StatelessWidget {
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
  late List<Task> originalTasks = tasks;
  TaskStatus filter = TaskStatus.all;
  DateTime selectedDate = DateTime.now();
  DateTime lastWeek = DateTime.now().subtract(Duration(days: 7));
  DateTime? selectedMonth;

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
      // response OK
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
      });
    } else {
      // Response Not Ok
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

// filter by date
  void filterTasksByDate(DateTime date) {
    setState(() {
      setFilter(TaskStatus.all);
      filter = TaskStatus.all;
      selectedDate = date;
      tasks = tasks.where((task) {
        final taskDate = DateFormat("yyyy-MM-dd").parse(task.date);
        return taskDate.isAtSameMomentAs(date);
      }).toList();
    });
  }

// filter of tasks of last week
  void filterTasksLastWeek() {
    setState(() {
      setFilter(TaskStatus.all);
      filter = TaskStatus.all;
      lastWeek = DateTime.now().subtract(Duration(days: 7));
      tasks = tasks.where((task) {
        final taskDate = DateFormat("yyyy-MM-dd").parse(task.date);
        return taskDate.isAfter(lastWeek) ||
            taskDate.isAtSameMomentAs(lastWeek);
      }).toList();
    });
  }

// filter by month
  void filterTasksByMonth(DateTime? month) {
    if (month == null) {
      return;
    }

    setState(() {
      setFilter(TaskStatus.all);
      filter = TaskStatus.all;
      selectedMonth = month;
      tasks = tasks.where((task) {
        final taskDate = DateFormat("yyyy-MM-dd").parse(task.date);
        return taskDate.month == month.month && taskDate.year == month.year;
      }).toList();
    });
  }

// date selection method
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

// month selection method
  void _selectMonth(BuildContext context) async {
    DateTime? picked = await showMonthPicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      filterTasksByMonth(picked);
    }
  }

// widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Manager',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue)),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterOption(
                  label: '     All     ',
                  selected: filter == TaskStatus.all,
                  onTap: () {
                    setFilter(TaskStatus.all);
                  },
                ),
                FilterOption(
                  label: '  Active  ',
                  selected: filter == TaskStatus.active,
                  onTap: () {
                    setFilter(TaskStatus.active);
                  },
                ),
                FilterOption(
                  label: 'Pending',
                  selected: filter == TaskStatus.pending,
                  onTap: () {
                    setFilter(TaskStatus.pending);
                  },
                ),
                FilterOption(
                  label: 'Completed',
                  selected: filter == TaskStatus.completed,
                  onTap: () {
                    setFilter(TaskStatus.completed);
                  },
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.calendar_today),
                  onSelected: (choice) {
                    if (choice == 'Last Week') {
                      filterTasksLastWeek();
                    } else if (choice == 'Select Month') {
                      _selectMonth(context);
                    } else if (choice == 'Select Date') {
                      _selectDate(context);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Last Week', 'Select Month', 'Select Date'}
                        .map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TaskCount(taskStatus: TaskStatus.active, tasks: tasks),
                  TaskCount(taskStatus: TaskStatus.completed, tasks: tasks),
                  TaskCount(taskStatus: TaskStatus.pending, tasks: tasks),
                ],
              ),
            ),
            margin: EdgeInsets.zero,
            elevation: 2,
          ),
          SizedBox(
            height: 18,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.only(top: 15),
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                 final task = tasks.reversed.toList()[index];
                  if (filter != TaskStatus.all && task.status != filter) {
                    return Container();
                  }

                  // date to be shown according to status
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
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

class FilterOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  FilterOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
