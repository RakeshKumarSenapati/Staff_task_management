import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class ImageList extends StatefulWidget {
  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  List<String> imageStrings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    var url = Uri.parse("https://creativecollege.in/img_retrive.php");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        try {
          List<dynamic> data = json.decode(response.body);
          setState(() {
            imageStrings = List<String>.from(data);
            isLoading = false; // Set loading to false when images are fetched
          });
        } catch (e) {
          print('Error decoding JSON: $e');
          throw Exception('Failed to load images');
        }
      } else {
        print('HTTP ${response.statusCode} ${response.body}');
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error fetching images: $e');
      throw Exception('Failed to load images');
    }
  }

  Future<void> _saveImage(Uint8List bytes, int index) async {
    try {
      final directory = await getExternalStorageDirectory();
      final image = File('${directory!.path}/image_$index.jpg');
      await image.writeAsBytes(bytes);
      Fluttertoast.showToast(
          msg: 'Image saved to gallery',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } on PlatformException catch (e) {
      print("Failed to save image: '$e'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    const _color1 = Color(0xFFC21E56);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _color1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: Text(
          'Notice Images',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(), // Loading indicator
            )
          : ListView.builder(
              itemCount: imageStrings.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImageGallery(
                            imageStrings,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "  Creative Techno College",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.download,color: Colors.red,),
                                  onPressed: () {
                                    _saveImage(base64Decode(imageStrings[index]), index);
                                  },
                                ),
                                SizedBox(
                                  height: 60,
                                )
                              ],
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Image.memory(
                                base64Decode(imageStrings[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class FullScreenImageGallery extends StatelessWidget {
  final List<String> imageStrings;
  final int initialIndex;

  FullScreenImageGallery(this.imageStrings, {required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    const _color1 = Color(0xFFC21E56);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 193, 181, 181),
      appBar: AppBar(
        title: Text(
          'Notice',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: _color1,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.indigo],
          ),
        ),
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          itemCount: imageStrings.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: MemoryImage(base64Decode(imageStrings[index])),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              heroAttributes: PhotoViewHeroAttributes(tag: index),
            );
          },
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          pageController: PageController(initialPage: initialIndex),
          onPageChanged: (index) {},
        ),
      ),
    );
  }
}
