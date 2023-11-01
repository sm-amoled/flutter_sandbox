import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sandbox/camera/reaction_hub_view.dart';

class ReactionEnterView extends StatelessWidget {
  const ReactionEnterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: ElevatedButton(
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
        ));
  }
}
