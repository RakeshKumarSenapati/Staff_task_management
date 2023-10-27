import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'mob_EditProfile.dart';
import 'mob_login.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile> {
  // Define variables to store the retrieved data
  String name = '';
  String userName = '';
  String password = '';
  String email = '';
  String phone = '';
  String address = '';
  String designation = '';

  // Function to fetch data from the API
  Future<void> fetchData() async {
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
          userName = firstElement['user_name'];
          password = firstElement['password'];
          email = firstElement['email'];
          phone = firstElement['phone'];
          address = firstElement['address'];
          designation = firstElement['designation'];
        });
      } else {
        // Handle the case where the JSON array is empty or not as expected
        setState(() {
          name = 'Data not found';
          userName = 'Data not found';
          password = 'Data not found';
        });
      }
    } else {
      // Handle the HTTP error
      throw Exception('Failed to load data');
    }
  }

  // Future<void> clearSharedPreferences() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('isLoggedIn');
  //   await prefs.remove('userID');
  //   await prefs.remove('password');
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => Mob_Login_Page()), // Navigate to your login screen
  //   );
  // }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userID');
    await prefs.remove('password');

    // Navigate to the login screen and remove all routes from the stack
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Mob_Login_Page()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PROFILE'),
        actions: <Widget>[
          Flexible(
            child: Column(
              children: [
                IconButton(
                  icon: Icon(Icons.logout_rounded,color: Color.fromARGB(255, 239, 61, 48),),
                  onPressed: () {
                    clearSharedPreferences();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/images/technocart.png'),
            ),
            const SizedBox(height: 10),
            Text(
              '$name',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$designation',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.only(left: 8, right: 8, top: 10),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text('$name'),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(left: 8, right: 8, top: 10),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.man_3_sharp),
                title: Text('$userName'),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(left: 8, right: 8, top: 10),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.email),
                title: Text('$email'),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(left: 8, right: 8, top: 10),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: Text('$phone'),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(left: 8, right: 8, top: 10),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: Text('$address'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfilePage(
                name: name,
                email: email,
                address: address,
                phone: phone,
                userName: userName,
              ),
            ),
          );
        },
        label: const Text('Edit Profile'),
        icon: const Icon(Icons.edit),
      ),
    );
  }
}
