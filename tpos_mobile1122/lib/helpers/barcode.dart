// // Copyright 2019 The Chromium Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.
//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui' show lerpDouble;
//
// //import 'package:camerakit/CameraKitController.dart';
// //import 'package:camerakit/CameraKitView.dart';
//
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:tpos_mobile/helpers/barcode/colors.dart';
//
// import 'barcode/scanner_utils.dart';
//
// enum AnimationState { search, barcodeNear, barcodeFound, endSearch }
//
// class BarcodeHelper extends StatefulWidget {
//   /// TODO reseach more
//   const BarcodeHelper({
//     this.validRectangle = const Rectangle(width: 340, height: 144),
//     this.frameColor = kShrineScrim,
//     this.traceMultiplier = 1.2,
//   });
//
//   final Rectangle validRectangle;
//   final Color frameColor;
//   final double traceMultiplier;
//
//   @override
//   _BarcodeHelperState createState() => _BarcodeHelperState();
// }
//
// class _BarcodeHelperState extends State<BarcodeHelper>
//     with TickerProviderStateMixin {
//   CameraController _cameraController;
//   AnimationController _animationController;
//   final bool _closeWindow = false;
//   String _barcodePictureFilePath;
//   Size _previewSize;
//   AnimationState _currentState = AnimationState.search;
//   CustomPainter _animationPainter;
//   int _animationStart = DateTime.now().millisecondsSinceEpoch;
//   final BarcodeDetector _barcodeDetector =
//       FirebaseVision.instance.barcodeDetector();
//   String _barcode = "";
//   String _lensDirection = "CameraLensDirection.back";
// //  CameraKitController cameraKitController;
//   Camera camera;
//   @override
//   void initState() {
// //    cameraKitController = CameraKitController();
//
//     SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);
//     SystemChrome.setPreferredOrientations(
//         <DeviceOrientation>[DeviceOrientation.portraitUp]);
//     _initCameraAndScanner();
//     _switchAnimationState(AnimationState.search);
//   }
//
//   void _initCameraAndScanner() {
//     ScannerUtils.getCamera(CameraLensDirection.back).then(
//       (CameraDescription camera) async {
//         _lensDirection = camera.lensDirection.toString();
//         await _openCamera(camera);
//         await _startStreamingImagesToScanner(camera.sensorOrientation);
//       },
//     );
//   }
//
//   void _initAnimation(Duration duration) {
//     _animationController = AnimationController(duration: duration, vsync: this);
//   }
//
//   void _switchAnimationState(AnimationState newState) {
//     if (newState == AnimationState.search) {
//       _initAnimation(const Duration(milliseconds: 750));
//
//       _animationPainter = RectangleOutlinePainter(
//         animation: RectangleTween(
//           Rectangle(
//             width: widget.validRectangle.width,
//             height: widget.validRectangle.height,
//             color: Colors.white,
//           ),
//           Rectangle(
//             width: widget.validRectangle.width * widget.traceMultiplier,
//             height: widget.validRectangle.height * widget.traceMultiplier,
//             color: Colors.transparent,
//           ),
//         ).animate(_animationController),
//       );
//
//       _animationController.addStatusListener((AnimationStatus status) {
//         if (status == AnimationStatus.completed) {
//           Future<void>.delayed(const Duration(milliseconds: 1600), () {
//             if (_currentState == AnimationState.search) {
//               if (_animationController != null) {
//                 _animationController.forward(from: 0);
//               }
//             }
//           });
//         }
//       });
//     } else if (newState == AnimationState.barcodeNear ||
//         newState == AnimationState.barcodeFound ||
//         newState == AnimationState.endSearch) {
//       double begin;
//       if (_currentState == AnimationState.barcodeNear) {
//         begin = lerpDouble(0.0, 0.5, _animationController.value);
//       } else if (_currentState == AnimationState.search) {
//         _initAnimation(const Duration(milliseconds: 500));
//         begin = 0.0;
//       }
//
//       _animationPainter = RectangleTracePainter(
//         rectangle: Rectangle(
//           width: widget.validRectangle.width,
//           height: widget.validRectangle.height,
//           color: newState == AnimationState.endSearch
//               ? Colors.transparent
//               : Colors.white,
//         ),
//         animation: Tween<double>(
//           begin: begin,
//           end: newState == AnimationState.barcodeNear ? 0.5 : 1.0,
//         ).animate(_animationController),
//       );
//
//       if (newState == AnimationState.barcodeFound) {
//         _animationController.addStatusListener((AnimationStatus status) {
//           if (status == AnimationStatus.completed) {
//             Future<void>.delayed(const Duration(milliseconds: 300), () {
//               if (_currentState != AnimationState.endSearch) {
//                 _switchAnimationState(AnimationState.endSearch);
//               }
//             });
//           }
//         });
//       }
//     }
//
//     _currentState = newState;
//     if (newState != AnimationState.endSearch) {
//       _animationController.forward(from: 0);
//       _animationStart = DateTime.now().millisecondsSinceEpoch;
//     }
//   }
//
//   Future<void> _openCamera(CameraDescription camera) async {
//     final ResolutionPreset preset =
//         defaultTargetPlatform == TargetPlatform.android
//             ? ResolutionPreset.medium
//             : ResolutionPreset.low;
//
//     _cameraController = CameraController(camera, preset);
//
//     await _cameraController.initialize();
//     _previewSize = _cameraController.value.previewSize;
//     setState(() {});
//   }
//
//   Future<void> _startStreamingImagesToScanner(int sensorOrientation) async {
//     final MediaQueryData data = MediaQuery.of(context);
//
//     _cameraController.startImageStream((CameraImage image) {
//       ScannerUtils.detect(
//         image: image,
//         detectInImage: _barcodeDetector.detectInImage,
//         imageRotation: sensorOrientation,
//       ).then(
//         (dynamic result) {
//           _handleResult(
//             barcodes: result,
//             data: data,
//             imageSize: Size(image.width.toDouble(), image.height.toDouble()),
//           );
//         },
//       );
//     });
//   }
//
//   Future<void> _handleResult({
//     @required List<Barcode> barcodes,
//     @required MediaQueryData data,
//     @required Size imageSize,
//   }) async {
//     final EdgeInsets padding = data.padding;
//     final double maxLogicalHeight =
//         data.size.height - padding.top - padding.bottom;
//
// //     Width & height are flipped from CameraController.previewSize on iOS
//     final double imageHeight = defaultTargetPlatform == TargetPlatform.iOS
//         ? imageSize.height
//         : imageSize.width;
//
//     final double imageScale = imageHeight / maxLogicalHeight;
//
//     final double halfWidth = imageScale * widget.validRectangle.width / 2;
//     final double halfHeight = imageScale * widget.validRectangle.height / 2;
//     final Offset center = imageSize.center(Offset.zero);
//     final Rect validRect1 = Rect.fromLTRB(
//       center.dy - halfWidth,
//       center.dx - halfHeight,
//       center.dy + halfWidth,
//       center.dx + halfHeight,
//     );
//     for (final Barcode barcode in barcodes) {
//       bool doesContain = false;
//       if (!barcode.rawValue.contains("error")) {
//         doesContain = validRect1.top <= barcode.boundingBox.top &&
//             144 >= barcode.boundingBox.height &&
//             validRect1.top + 144 >=
//                 barcode.boundingBox.top + barcode.boundingBox.height;
//       }
//       if (doesContain) {
//         _barcode += barcode.rawValue;
//         await _cameraController?.stopImageStream();
//         Navigator.pop(context, _barcode);
//       } else if (barcode.boundingBox.overlaps(validRect1)) {
//         if (_currentState != AnimationState.barcodeNear) {
//           _switchAnimationState(AnimationState.barcodeNear);
//           setState(() {});
//         }
//         return;
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _animationController?.dispose();
//     _animationController = null;
//     _dispose();
//     super.dispose();
//   }
//
//   Future<void> _dispose() async {
//     await _cameraController?.dispose();
//     await _barcodeDetector.close();
//   }
//
//   Widget _buildCameraPreview() {
//     return Container(
//       color: Colors.black,
//       child: Transform.scale(
//         scale: _getImageZoom(MediaQuery.of(context)),
//         child: Center(
//           child: AspectRatio(
//             aspectRatio: _cameraController.value.aspectRatio,
//             child: CameraPreview(_cameraController),
//           ),
//         ),
//       ),
//     );
//   }
//
//   double _getImageZoom(MediaQueryData data) {
//     final double logicalWidth = data.size.width;
//     final double logicalHeight = _previewSize.aspectRatio * logicalWidth;
//
//     final EdgeInsets padding = data.padding;
//     final double maxLogicalHeight =
//         data.size.height - padding.top - padding.bottom;
//
//     return maxLogicalHeight / logicalHeight;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Widget background;
//     if (_barcodePictureFilePath != null) {
//       background = Container(
//         color: Colors.black,
//         child: Transform.scale(
//           scale: _getImageZoom(MediaQuery.of(context)),
//         ),
//       );
//     } else if (_cameraController != null &&
//         _cameraController.value.isInitialized) {
//       background = _buildCameraPreview();
//     } else {
//       background = Container(
//         color: Colors.black,
//       );
//     }
//
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: <Widget>[
//             background,
//             Container(
//               constraints: const BoxConstraints.expand(),
//               child: CustomPaint(
//                 painter: WindowPainter(
//                   windowSize: Size(widget.validRectangle.width,
//                       widget.validRectangle.height),
//                   outerFrameColor: widget.frameColor,
//                   closeWindow: _closeWindow,
//                   innerFrameColor: _currentState == AnimationState.endSearch
//                       ? Colors.transparent
//                       : kShrineFrameBrown,
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 0,
//               right: 0,
//               top: 0,
//               child: Container(
//                 height: 56,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: <Color>[Colors.black87, Colors.transparent],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               constraints: const BoxConstraints.expand(),
//               child: CustomPaint(
//                 painter: _animationPainter,
//               ),
//             ),
//             AppBar(
//               leading: IconButton(
//                 icon: const Icon(Icons.close, color: Colors.white),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//               backgroundColor: Colors.transparent,
//               elevation: 0.0,
//               actions: [
//                 if (_lensDirection == "CameraLensDirection.back")
//                   IconButton(
//                       icon: Row(
//                         children: const [
//                           Icon(Icons.flash_auto_sharp),
//                           Text("Flash")
//                         ],
//                       ),
//                       onPressed: () async {
// //                          cameraKitController
// //                              .changeFlashMode(CameraFlashMode.on);`
//                         try {
// //                          Flashlight.lightOn();
// //                          TorchCompat.turnOn();
// //                          AdvCameraController cameraController;
// //                          _cameraController.setFlashType(FlashType.torch);
// //                          await cameraController.setFlashType(FlashType.torch);
//                         } catch (e) {
//                           print(e);
//                         }
//                       })
//                 else
//                   const SizedBox()
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class WindowPainter extends CustomPainter {
//   WindowPainter({
//     @required this.windowSize,
//     this.outerFrameColor = Colors.white54,
//     this.innerFrameColor = const Color(0xFF442C2E),
//     this.innerFrameStrokeWidth = 3,
//     this.closeWindow = false,
//   });
//
//   final Size windowSize;
//   final Color outerFrameColor;
//   final Color innerFrameColor;
//   final double innerFrameStrokeWidth;
//   final bool closeWindow;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Offset center = size.center(Offset.zero);
//     final double windowHalfWidth = windowSize.width / 2;
//     final double windowHalfHeight = windowSize.height / 2;
//
//     final Rect windowRect = Rect.fromLTRB(
//       center.dx - windowHalfWidth,
//       center.dy - windowHalfHeight,
//       center.dx + windowHalfWidth,
//       center.dy + windowHalfHeight,
//     );
//
//     final Rect left =
//         Rect.fromLTRB(0, windowRect.top, windowRect.left, windowRect.bottom);
//     final Rect top = Rect.fromLTRB(0, 0, size.width, windowRect.top);
//     final Rect right = Rect.fromLTRB(
//       windowRect.right,
//       windowRect.top,
//       size.width,
//       windowRect.bottom,
//     );
//     final Rect bottom = Rect.fromLTRB(
//       0,
//       windowRect.bottom,
//       size.width,
//       size.height,
//     );
//
//     canvas.drawRect(
//         windowRect,
//         Paint()
//           ..color = innerFrameColor
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = innerFrameStrokeWidth);
//
//     final Paint paint = Paint()..color = outerFrameColor;
//     canvas.drawRect(left, paint);
//     canvas.drawRect(top, paint);
//     canvas.drawRect(right, paint);
//     canvas.drawRect(bottom, paint);
//
//     if (closeWindow) {
//       canvas.drawRect(windowRect, paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(WindowPainter oldDelegate) =>
//       oldDelegate.closeWindow != closeWindow;
// }
//
// class Rectangle {
//   const Rectangle({this.width, this.height, this.color});
//
//   final double width;
//   final double height;
//   final Color color;
//
//   static Rectangle lerp(Rectangle begin, Rectangle end, double t) {
//     Color color;
//     if (t > .5) {
//       color = Color.lerp(begin.color, end.color, (t - .5) / .25);
//     } else {
//       color = begin.color;
//     }
//
//     return Rectangle(
//       width: lerpDouble(begin.width, end.width, t),
//       height: lerpDouble(begin.height, end.height, t),
//       color: color,
//     );
//   }
// }
//
// class RectangleTween extends Tween<Rectangle> {
//   RectangleTween(Rectangle begin, Rectangle end)
//       : super(begin: begin, end: end);
//
//   @override
//   Rectangle lerp(double t) => Rectangle.lerp(begin, end, t);
// }
//
// class RectangleOutlinePainter extends CustomPainter {
//   RectangleOutlinePainter({
//     @required this.animation,
//     this.strokeWidth = 3,
//   }) : super(repaint: animation);
//
//   final Animation<Rectangle> animation;
//   final double strokeWidth;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Rectangle rectangle = animation.value;
//
//     final Paint paint = Paint()
//       ..strokeWidth = strokeWidth
//       ..color = rectangle.color
//       ..style = PaintingStyle.stroke;
//
//     final Offset center = size.center(Offset.zero);
//     final double halfWidth = rectangle.width / 2;
//     final double halfHeight = rectangle.height / 2;
//
//     final Rect rect = Rect.fromLTRB(
//       center.dx - halfWidth,
//       center.dy - halfHeight,
//       center.dx + halfWidth,
//       center.dy + halfHeight,
//     );
//
//     canvas.drawRect(rect, paint);
//   }
//
//   @override
//   bool shouldRepaint(RectangleOutlinePainter oldDelegate) => false;
// }
//
// class RectangleTracePainter extends CustomPainter {
//   RectangleTracePainter({
//     @required this.animation,
//     @required this.rectangle,
//     this.strokeWidth = 3,
//   }) : super(repaint: animation);
//
//   final Animation<double> animation;
//   final Rectangle rectangle;
//   final double strokeWidth;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double value = animation.value;
//
//     final Offset center = size.center(Offset.zero);
//     final double halfWidth = rectangle.width / 2;
//     final double halfHeight = rectangle.height / 2;
//
//     final Rect rect = Rect.fromLTRB(
//       center.dx - halfWidth,
//       center.dy - halfHeight,
//       center.dx + halfWidth,
//       center.dy + halfHeight,
//     );
//
//     final Paint paint = Paint()
//       ..strokeWidth = strokeWidth
//       ..color = rectangle.color;
//
//     final double halfStrokeWidth = strokeWidth / 2;
//
//     final double heightProportion = (halfStrokeWidth + rect.height) * value;
//     final double widthProportion = (halfStrokeWidth + rect.width) * value;
//
//     canvas.drawLine(
//       Offset(rect.right, rect.bottom + halfStrokeWidth),
//       Offset(rect.right, rect.bottom - heightProportion),
//       paint,
//     );
//
//     canvas.drawLine(
//       Offset(rect.right + halfStrokeWidth, rect.bottom),
//       Offset(rect.right - widthProportion, rect.bottom),
//       paint,
//     );
//
//     canvas.drawLine(
//       Offset(rect.left, rect.top - halfStrokeWidth),
//       Offset(rect.left, rect.top + heightProportion),
//       paint,
//     );
//
//     canvas.drawLine(
//       Offset(rect.left - halfStrokeWidth, rect.top),
//       Offset(rect.left + widthProportion, rect.top),
//       paint,
//     );
//   }
//
//   @override
//   bool shouldRepaint(RectangleTracePainter oldDelegate) => false;
// }
