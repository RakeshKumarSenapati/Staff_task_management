import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/mobile/mob_EditProfile.dart';
import 'package:flutter_application_1/mobile/mob_login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile> {
  String name = '';
  String userName = '';
  String password = '';
  String email = '';
  String phone = '';
  String address = '';
  String designation = '';
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  late String pickedImagePath;

  @override
  void initState() {
    super.initState();
    loadImagePath();
    fetchData();
  }

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
          email = 'Data not found';
          phone = 'Data not found';
          address = 'Data not found';
          designation = 'Data not found';
        });
      }
    } else {
      // Handle the HTTP error
      throw Exception('Failed to load data');
    }
  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('isLoggedInAdmin');
    await prefs.remove('userID');
    await prefs.remove('password');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Mob_Login_Page()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      pickedImagePath = pickedImage.path;
      await saveImagePath(pickedImagePath);

      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  Future<void> saveImagePath(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('pickedImagePath', imagePath);
  }

  Future<void> loadImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedImagePath = prefs.getString('pickedImagePath');

    setState(() {
      if (savedImagePath != null) {
        _pickedImage = XFile(savedImagePath);
      }
    });
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
                  icon: Icon(
                    Icons.logout_rounded,
                    color: Color.fromARGB(255, 239, 61, 48),
                  ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: _pickedImage == null
                            ? AssetImage('assets/images/technocart.png')
                            : FileImage(File(_pickedImage!.path))
                                as ImageProvider<Object>?,
                      ),
                      Positioned(
                        bottom: 13,
                        left: 101,
                        child: GestureDetector(
                          onTap: () {
                            _pickImage();
                          },
                          child: Icon(Icons.add_a_photo_rounded,
                              size: 40, // Adjust the size of the plus icon
                              color: const Color.fromARGB(255, 2, 95,
                                  255) // Adjust the color of the plus icon
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            FadeInUp(
              duration: Duration(milliseconds: 3000),
              child: Text(
                '$name',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              duration: Duration(milliseconds: 3000),
              child: Text(
                '$designation',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeInLeft(
              duration: Duration(milliseconds: 3000),
              child: Card(
                margin: const EdgeInsets.only(left: 8, right: 8, top: 10),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('$name'),
                ),
              ),
            ),
            FadeInRight(
              duration: Duration(milliseconds: 3000),
              child: Card(
                margin: const EdgeInsets.only(left: 8, right: 8, top: 10),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.man_3_sharp),
                  title: Text('$userName'),
                ),
              ),
            ),
            FadeInLeft(
              duration: Duration(milliseconds: 3000),
              child: Card(
                margin: const EdgeInsets.only(left: 8, right: 8, top: 10),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.email),
                  title: Text('$email'),
                ),
              ),
            ),
            FadeInRight(
              duration: Duration(milliseconds: 3000),
              child: Card(
                margin: const EdgeInsets.only(left: 8, right: 8, top: 10),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text('$phone'),
                ),
              ),
            ),

            FadeInLeft(
              duration: Duration(milliseconds: 3000),
              child: Card(
                margin: const EdgeInsets.only(left: 8, right: 8, top: 10),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text('$address'),
                ),
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
