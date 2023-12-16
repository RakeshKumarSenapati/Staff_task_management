import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String address;
  final String phone;
  final String userName;

  EditProfilePage({
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.userName,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  XFile? _pickedImage;
  late String pickedImagePath;

  Future<void> _editProfile() async {
    final response = await http.post(
      Uri.parse('https://creativecollege.in/Flutter/EditProfile.php'),
      body: {
        'user': widget.userName,
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
      },
    );

    if (response.statusCode == 200) {
      if (response.body == "Success") {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Profile updated successfully'),
        ));
        // You can also navigate back to the previous page or perform other actions
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Profile update failed'),
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadImagePath();
    nameController.text = widget.name;
    emailController.text = widget.email;
    usernameController.text = widget.userName;
    phoneController.text = widget.phone;
    addressController.text = widget.address;
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
        title: const Text('Edit Profile')
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
             CircleAvatar(
              radius: 70,
              backgroundImage: _pickedImage == null
                    ? AssetImage('assets/images/technocart.png')
                    : FileImage(File(_pickedImage!.path)) as ImageProvider<Object>?,
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Enter New Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_circle_rounded),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Enter New Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.man_sharp),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Enter New Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Enter New Phone',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Enter New Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _editProfile(); // Call the function to update the profile
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Edit',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
