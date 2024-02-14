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
      downloadedFilePath = '$appDocPath/${DateTime.now().millisecondsSinceEpoch}.pdf';

      await dio.download(url, downloadedFilePath);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : PDFView(
                filePath: downloadedFilePath,
              ),
      ),
    );
  }
}
