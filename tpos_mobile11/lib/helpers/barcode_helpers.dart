import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class BarcodeHelper {
  List<CameraDescription> cameras;
  CameraDescription camera;
  CameraController controller;

  Future<void> setUpCamera() async{
    // CameraPreview(controller);
    camera = await availableCameras().then(  (List<CameraDescription> cameras) => cameras.firstWhere(
          (CameraDescription camera) => camera.lensDirection == CameraLensDirection.back,
    ),);
    // CameraDescription description = await getCa
    final ResolutionPreset preset =
    defaultTargetPlatform == TargetPlatform.android
        ? ResolutionPreset.medium
        : ResolutionPreset.low;
    controller = CameraController(camera, preset);
    await controller.initialize();
    CameraPreview(controller);
    // File file = await _takePicture();
    //     // await _readBarcode(file);

  }

  Future<File> _takePicture() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/barcode';
    await Directory(dirPath).create(recursive: true);
    final File file = new File('$dirPath/barcode.jpg');

    if(await file.exists())
      await file.delete();

    await controller.takePicture(file.path);
    return file;
  }

  Future _readBarcode(File file) async {
    String _barcodeRead = "";
    FirebaseVisionImage firebaseImage = FirebaseVisionImage.fromFile(file);
    final BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();

    final List<Barcode> barcodes = await barcodeDetector.detectInImage(firebaseImage);

    _barcodeRead = "";
    for(Barcode barcode in barcodes) {
      _barcodeRead += barcode.rawValue + ", ";
    }
  }

  void dispose(){
    controller?.dispose();
  }
}