import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';

class BarcodeScan extends StatefulWidget {
  @override
  _BarcodeScanState createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<BarcodeScan> {
  var flashState = flashOn;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: 300,
          ),
        ),
        Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    if (controller != null) {
                      controller.toggleFlash();
                      if (_isFlashOn(flashState)) {
                        setState(() {
                          flashState = flashOff;
                        });
                      } else {
                        setState(() {
                          flashState = flashOn;
                        });
                      }
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      if (flashState == flashOn)
                        const Icon(Icons.flash_off)
                      else
                        const Icon(Icons.flash_on),
                      const SizedBox(
                        width: 4,
                      ),
                      if (flashState == flashOn)
                        const Text("Flash off")
                      else
                        const Text("Flash on")
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((String scanData) {
      controller.dispose();
      Navigator.pop(context, scanData);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
