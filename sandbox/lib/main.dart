import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sandbox/camera/camera_page.dart';
import 'package:sandbox/home.dart';

Future<void> main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
