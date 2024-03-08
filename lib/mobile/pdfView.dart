import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:printing/printing.dart';

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
    _onDownloadPressed();
  }


  Future<void> _onDownloadPressed() async {
    try {
      // await downloadFile(widget.url);
    } catch (e) {
      print(e.toString());
    }
  }

  void _handlePrint(BuildContext context) async {
    try {
      await Printing.layoutPdf(
        onLayout: (_) => File(downloadedFilePath).readAsBytes(),
      );
    } catch (e) {
      print("Error printing PDF: $e");
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
            icon: Icon(Icons.print, color: Colors.white),
            onPressed: () {
              _handlePrint(context);
            },
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
