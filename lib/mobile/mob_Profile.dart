import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'mob_EditProfile.dart';
import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
  String designation='';
  
  // Function to fetch data from the API
  Future<void> fetchData() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? '';
    final response = await http.get(Uri.parse('https://creativecollege.in/Flutter/Profile.php?id=$userID'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      // Check if jsonData is a list and not empty
      if (jsonData is List && jsonData.isNotEmpty) {
        // Access the first element of the list (assuming there is only one element)
        final firstElement = jsonData[0];

        // Access the specific fields within the first element
        setState(() {
          name = firstElement['name'];
          userName = firstElement['user_name'];
          password = firstElement['password'];
          email = firstElement['email'];
          phone = firstElement['phone'];
          address = firstElement['address'];
          designation= firstElement['designation'];
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

// Future<void> _selectProfilePhoto() async {
//   PermissionStatus status = await Permission.photos.request();

//   if (status.isGranted) {
//     final image = await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (image != null) {
//       // Handle the selected image
//       setState(() {
//         _selectedImage = File(image.path);
//       });
//     } else {
//       // Handle the case when the user cancels image selection
//     }
//   } else if (status.isDenied) {
//     // Handle the case when the user denies permission
//     // You can display a message or request permission again
//   } else {
//     // Handle other permission statuses if needed
//   }
// }
  
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFILE'),
      ),
       body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            // GestureDetector(
            // onTap: _selectProfilePhoto,
               CircleAvatar(
              radius: 80,
               backgroundImage: AssetImage('assets/images/technocart.png'),

            ),
            //),
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
               margin: const EdgeInsets.only(left: 8,right: 8,top: 10),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text('$name'),
              ),
            ),
            Card(
               margin: const EdgeInsets.only(left: 8,right: 8,top: 10),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.man_3_sharp),
                title: Text('$userName'),
              ),
            ),
            Card(
               margin: const EdgeInsets.only(left: 8,right: 8,top: 10),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.email),
                title: Text('$email'),
              ),
            ),
            Card(
               margin: const EdgeInsets.only(left: 8,right: 8,top: 10),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: Text('$phone'),
              ),
            ),
            Card(
               margin: const EdgeInsets.only(left: 8,right: 8,top: 10),
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
                address:address,
                phone:phone,
                userName:userName
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