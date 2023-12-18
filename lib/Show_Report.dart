import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfListScreen extends StatefulWidget {
  @override
  _PdfListScreenState createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> {
  List<String> pdfFileNames = [];
  int selectedPdfIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchPdfFileList();
  }

  Future<void> fetchPdfFileList() async {
    final apiUrl = 'https://creativecollege.in/Flutter/Report/Pdflist.php'; // Replace with your API endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<String> fileNames = List<String>.from(data['pdfFiles']);

        setState(() {
          pdfFileNames = fileNames;
        });
      } else {
        print('Failed to load PDF list. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching PDF list: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF File List'),
      ),
      body: selectedPdfIndex == -1
          ? pdfListWidget()
          : pdfViewerWidget(pdfFileNames[selectedPdfIndex]),
    );
  }

  Widget pdfListWidget() {
    return pdfFileNames.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: pdfFileNames.length,
            itemBuilder: (context, index) {
              final pdfFileName = pdfFileNames[index];
              return ListTile(
                title: Text(pdfFileName),
                onTap: () {
                  setState(() {
                    selectedPdfIndex = index;
                  });
                },
              );
            },
          );
  }

  Widget pdfViewerWidget(String pdfFileName) {
    return PDFView(
      filePath: 'https://your-api-endpoint.com/pdfs/$pdfFileName',
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PdfListScreen(),
  ));
}
