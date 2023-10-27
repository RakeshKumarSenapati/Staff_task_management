import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/mobile/mob_navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
const bgColor = Color(0xfffafafa);

class QrCodeScanner extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QrCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedCode = '';

  Future<void> ATTENDANCE() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? '';
    var url = Uri.parse('https://creativecollege.in/Flutter/Attendance.php?userID=$userID');

    var response = await http.get(url);
    if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: response.body,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavPage()),
          result: MaterialPageRoute(builder: (context) => NavPage()),
        );
       
      
    }
    }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "QR Scaner",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Place the QR code in the area",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Scanning will be started automatically",
                      style: TextStyle(color: Colors.black54, fontSize: 14))
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                    borderColor: Color.fromARGB(255, 5, 136, 243),
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 200),
              ),
            ),
            Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          child: const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/technocart.png'),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          "Powered by Technocract",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    )))
          ],
        ),
      ),
    );
  }

// zeoytawvtn : code of QR

  void _onQRViewCreated(QRViewController controller) {
    bool showSuccessAlert = false;
    bool showFailureAlert = false;

    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Matching the QR code
      if (scanData.code! == "creative" && !showSuccessAlert) {
        setState(() {
          showSuccessAlert = true;
        });
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green, // Icon color
                  size: 40.0, // Icon size
                ),
                Text('Registration Successful'),
              ],
            ),
            content: const Text(
              'You have successfully registered for our service.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.pauseCamera();
                    ATTENDANCE();
                    Navigator.of(context).pop(); 
                  },
                  child: Text("Mark Attendance"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.blue), // Background color
                    padding: MaterialStateProperty.all(EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 10,
                        bottom: 10)), // Button padding
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Border radius
                    )),
                    textStyle: MaterialStateProperty.all(TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 16.0, // Text size
                      fontWeight: FontWeight.bold, // Text style
                    )),
                  ),
                ),
              )
            ],
          ),
        );
      }

      // Mismatching the QR code
      if (scanData.code! != "creative" && !showFailureAlert) {
        setState(() {
          showFailureAlert = true;
        });
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.orange,
                  size: 40.0,
                ),
                const Text('Registration Failed'),
              ],
            ),
            content: const Text(
              'Incorrect Id found please try again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QrCodeScanner()),
                  ),
                  child: const Text('Try Again'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.blue), // Background color
                    padding: MaterialStateProperty.all(EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 10,
                        bottom: 10)), // Button padding
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Border radius
                    )),
                    textStyle: MaterialStateProperty.all(TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 14.0, // Text size
                      fontWeight: FontWeight.bold, // Text style
                    )),
                  ),
                ),
              )
            ],
          ),
        );
      }
    });
  }
}
