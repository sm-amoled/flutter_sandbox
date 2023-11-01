import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path_provider/path_provider.dart';

class ReactionHubViewForDEBUG extends StatefulWidget {
  ReactionHubViewForDEBUG({super.key, required this.cameraController});

  CameraController cameraController;

  @override
  State<ReactionHubViewForDEBUG> createState() =>
      _ReactionHubViewForDEBUGState();
}

class _ReactionHubViewForDEBUGState extends State<ReactionHubViewForDEBUG> {
  late GlobalKey repaintBoundaryGlobalKey;

  double originXOffset = 100;
  double originYOffset = 100;

  double xOffset = 100;
  double yOffset = 100;

  late double screenWidth;
  late double screenHeight;

  late double cameraWidgetPositionX;
  late double cameraWidgetPositionY;
  late double cameraWidgetRadius;

  late CameraController _controller;

  bool isShowingCameraView = false;

  bool isFingerInCameraArea(Point offset) {
    if (offset.distanceTo(Point(
            screenWidth / 2, cameraWidgetPositionY + cameraWidgetRadius)) <
        cameraWidgetRadius) {
      return true;
    }
    print("false");
    return false;
  }

  bool isCameraButtonPanned(Point offset) {
    if (offset.distanceTo(Point(originXOffset, originYOffset)) >= 30) {
      return true;
    }
    return false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    screenWidth = View.of(context).physicalSize.width / 3;
    screenHeight = View.of(context).physicalSize.height / 3;

    cameraWidgetPositionX = screenWidth / 2;
    cameraWidgetPositionY = screenHeight / 2.5;
    cameraWidgetRadius = screenWidth / 3;
  }

  @override
  void initState() {
    super.initState();
    repaintBoundaryGlobalKey = GlobalKey();
    _controller = widget.cameraController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Temp Reaction View For DEBUG"),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black45
                        .withOpacity(isShowingCameraView ? 0.7 : 0)),
              ),
            ),
            Positioned(
              bottom: cameraWidgetPositionY,
              width: cameraWidgetRadius * 2,
              height: cameraWidgetRadius * 2 * _controller.value.aspectRatio,
              child: Opacity(
                opacity: isShowingCameraView ? 0.7 : 0,
                child: RepaintBoundary(
                  key: repaintBoundaryGlobalKey,
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: CameraPreview(_controller)),
                ),
              ),
            ),
            Positioned(
              left: xOffset,
              bottom: yOffset,
              child: GestureDetector(
                onTapDown: (details) async {},
                onPanUpdate: (details) {
                  setState(() {
                    xOffset = xOffset + details.delta.dx;
                    yOffset = yOffset - details.delta.dy;
                  });
                  isFingerInCameraArea(Point(xOffset, yOffset));
                  isShowingCameraView =
                      isCameraButtonPanned(Point(xOffset, yOffset));
                },
                onPanEnd: (details) async {
                  if (isFingerInCameraArea(Point(xOffset, yOffset))) {
                    // final fileImage = await cropSquare();
                    // final image = await getSquarePhotoImageFromCamera();
                    final fileImage = FileImage(File(await _capture()));
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ImageSampleView(fileImage: fileImage)));
                  }

                  setState(() {
                    xOffset = originXOffset;
                    yOffset = originYOffset;
                    isShowingCameraView = false;
                  });
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<FileImage> cropSquare() async {
    final filePath = await _capture();

    // XFile? file = await _controller.takePicture();

    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(filePath);

    var cropSize = min(properties.width!, properties.height!);
    int offsetX = (properties.width! - cropSize) ~/ 2;
    int offsetY = (properties.height! - cropSize) ~/ 2;

    final imageFile = await FlutterNativeImage.cropImage(
        filePath, offsetX, offsetY, cropSize, cropSize);

    return Future(() => FileImage(imageFile));
  }

  Future<String> _capture() async {
    print("START CAPTURE");
    var renderObject =
        repaintBoundaryGlobalKey.currentContext?.findRenderObject();
    if (renderObject is RenderRepaintBoundary) {
      var boundary = renderObject;
      ui.Image image = await boundary.toImage();
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      print(pngBytes);
      File imgFile =
          new File('$directory/screenshot${DateTime.now().toString()}.png');
      imgFile.writeAsBytes(pngBytes);
      print("FINISH CAPTURE ${imgFile.path}");

      return imgFile.path;
    } else {
      return "";
    }
  }
}

class ImageSampleView extends StatelessWidget {
  ImageSampleView({super.key, required this.fileImage});

  FileImage fileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: Center(
              child: Image(
        image: fileImage,
      ))),
    );
  }
}
