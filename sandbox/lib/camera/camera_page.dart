import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  CameraPage({super.key, required this.controller});

  CameraController controller;
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;

  // late var imageFile;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _initializeCamera();
  }

  void _initializeCamera() async {
    // element tree에 본 state가 잘 들어와있는지 확인하는 코드인 것 같음
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: CameraPreview(_controller),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _takePicture(context),
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Future<void> _takePicture(BuildContext context) async {
    final path =
        join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');
    XFile file = await _controller.takePicture();

    file.saveTo(path);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImageScreen(imagePath: path)));
  }
}

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.file(File(imagePath)),
    );
  }
}
