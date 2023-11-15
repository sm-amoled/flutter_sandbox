import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sandbox/camera/camera_page.dart';

class CameraIntroPage extends StatefulWidget {
  const CameraIntroPage({super.key});

  @override
  State<CameraIntroPage> createState() => _CameraIntroPageState();
}

class _CameraIntroPageState extends State<CameraIntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Camera Test"),
        ),
        body: Container(
          child: Center(
              child: ElevatedButton(
            child: Text("CAMERA ON"),
            onPressed: () async {
              CameraController _controller;
              CameraDescription description =
                  await availableCameras().then((cameras) => cameras.first);
              _controller =
                  CameraController(description, ResolutionPreset.medium);
              await _controller.initialize();

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CameraPage(controller: _controller);
              }));
            },
          )),
        ));
  }
}
