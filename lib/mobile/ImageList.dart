import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

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
            imageStrings = List<String>.from(data).reversed.toList();
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
          'Notice',
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
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () {
              _handlePrint(context);
            },
          ),
        ],
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

  void _handlePrint(BuildContext context) async {
    try {
      final doc = pw.Document();
      for (final imageString in imageStrings) {
        final image = pw.MemoryImage(base64Decode(imageString));
        doc.addPage(pw.Page(build: (pw.Context context) {
          return pw.Center(child: pw.Image(image));
        }));
      }
      await Printing.layoutPdf(onLayout: (_) => doc.save());
    } catch (e) {
      print("Error printing document: $e");
    }
  }
}
