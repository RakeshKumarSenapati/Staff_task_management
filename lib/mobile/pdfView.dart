import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewer extends StatefulWidget {
  final String url;

  PDFViewer({required this.url});

  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  bool isLoading = true;
  late String downloadedFilePath;
  int currentPage = 0;
  int totalPages = 0;

  @override
  void initState() {
    super.initState();
    downloadFile(widget.url);
  }

  Future<void> downloadFile(String url) async {
    try {
      Dio dio = Dio();
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;
      downloadedFilePath =
          '$appDocPath/${DateTime.now().millisecondsSinceEpoch}.pdf';

      await dio.download(url, downloadedFilePath);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _onDownloadPressed() async {
    try {
      await downloadFile(widget.url);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    const _color1 = Color(0xFFC21E56);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View The Report',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: _color1,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.download,
            color: Colors.white,
            ),
            onPressed: _onDownloadPressed,
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              )
            : Column(
                children: [
                  Expanded(
                    child: PDFView(
                      filePath: downloadedFilePath,
                      onPageChanged: (page, total) {
                        setState(() {
                          currentPage = page!;
                          totalPages = total!;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    color: _color1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Page ${currentPage + 1} of $totalPages',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
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
