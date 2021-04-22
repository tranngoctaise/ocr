import 'package:flutter/material.dart';
import 'package:ocr_demo/home_screen.dart';
// import 'package:camera/camera.dart';

// Global variable for storing the list of
// cameras available
// List<CameraDescription> cameras = [];
Future<void> main() async {
  // try {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   // Retrieve the device cameras
  //   cameras = await availableCameras();
  // } on CameraException catch (e) {
  //   print(e);
  // }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kích hoạt bảo hành',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(null)
    );
  }
}
