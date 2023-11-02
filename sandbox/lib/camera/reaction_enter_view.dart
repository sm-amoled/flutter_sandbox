import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sandbox/camera/emoji_picker_view.dart';
import 'package:sandbox/camera/reaction_hub_view.dart';
import 'package:sandbox/camera/text_sender_page.dart';

class ReactionEnterView extends StatelessWidget {
  const ReactionEnterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                child: Text("GO TO HUB"),
                onPressed: () async {
                  CameraDescription description = await availableCameras().then(
                      (cameras) => cameras.firstWhere((camera) =>
                          camera.lensDirection == CameraLensDirection.front));
                  CameraController _controller =
                      CameraController(description, ResolutionPreset.medium);

                  await _controller.initialize();

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => ReactionHubViewForDEBUG(
                            cameraController: _controller,
                          ))));
                },
              ),
              ElevatedButton(
                child: Text("GO TO EMOJI PICKER"),
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => EmojiPickerView())));
                },
              ),
              ElevatedButton(
                child: Text("GO TO Text Sender"),
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => TextSenderPage())));
                },
              ),
            ],
          ),
        ));
  }
}
