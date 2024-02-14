import 'package:flutter/material.dart';
import 'package:flutter_application_1/mobile/mob_navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const bgColor = Color(0xfffafafa);

class QrCodeScanner extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}




class _QRScannerScreenState extends State<QrCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isScanCompleted = false;
  bool isFlashOn = false;
  bool isFrontCamera = false;
  var barCodeKey = "";
  bool showSuccessAlert = false;
  bool showFailureAlert = false;
  String scannedCode = '';
  MobileScannerController controller = MobileScannerController();




  Future<void> ATTENDANCE() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? '';
    var url = Uri.parse(
        'https://creativecollege.in/Flutter/Attendance.php?userID=$userID');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      String res = response.body;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$res'),
        ),
      );

      setState(() {
        showSuccessAlert = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavPage()),
      );
    }
  }

  void closeScreen() {
    isScanCompleted = false;
  }




  @override
  Widget build(BuildContext context) {
    const _color1 = Color(0xFFC21E56);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: _color1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFlashOn = !isFlashOn;
              });
              controller.toggleTorch();
            },
            icon: Icon(
              Icons.flash_on,
              color: isFlashOn ? Colors.blue : Colors.grey,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isFrontCamera = !isFrontCamera;
              });
              controller.switchCamera();
            },
            icon: Icon(
              Icons.camera_front,
              color: isFrontCamera ? Colors.blue : Colors.grey,
            ),
          ),
        ],
        title: const Text(
          "QR SCANNER",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
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
                  Text(
                    "Scanning will be started automatically",
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  MobileScanner(
                    controller: controller,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue == "creative" &&
                            !showSuccessAlert) {
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
                                    color: Colors.green,
                                    size: 40.0,
                                  ),
                                  Text(
                                    'Verify Successful',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              content: const Text(
                                'You have successfully registered for our service press check to take attendance.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                              actions: <Widget>[
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        showSuccessAlert = false;
                                      });
                                      ATTENDANCE();
                                    },
                                    child: const Text("Check"),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue),
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.only(
                                          left: 24,
                                          right: 24,
                                          top: 10,
                                          bottom: 10,
                                        ),
                                      ),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      textStyle: MaterialStateProperty.all(
                                        const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                          controller.stop();
                        } else {
                          if (!showFailureAlert) {
                            setState(() {
                              showFailureAlert = true;
                            });
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.warning,
                                      color: Colors.orange,
                                      size: 40.0,
                                    ),
                                    Text('Registration Failed'),
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
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          showFailureAlert = false;
                                        });
                                      },
                                      child: const Text('Try Again'),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue),
                                        padding: MaterialStateProperty.all(
                                          const EdgeInsets.only(
                                            left: 24,
                                            right: 24,
                                            top: 10,
                                            bottom: 10,
                                          ),
                                        ),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        textStyle: MaterialStateProperty.all(
                                          const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),
                  QRScannerOverlay(
                    overlayColor: bgColor,
                    borderColor: Colors.blue,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  "Powered by Technocrat",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
