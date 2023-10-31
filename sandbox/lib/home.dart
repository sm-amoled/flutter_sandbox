import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sandbox/camera/camera_intro_page.dart';
import 'package:sandbox/camera/camera_page.dart';
import 'package:sandbox/clap_button/clap_button_page.dart';
import 'package:sandbox/emoji_firework_animation/emoji_firework_page.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final sandboxList = [
    (ClapButtonPage(), "Clap Button Animation"),
    (EmojiFireworkPage(), "Emoji Firework"),
    (CameraIntroPage(), "Camera"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SandBox")),
      body: ListView.builder(
        itemCount: sandboxList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(context, CupertinoPageRoute(
                  Navigator.push(context, CupertinoPageRoute(
                    builder: (context) {
                      return sandboxList[index].$1;
                    },
                  ));
                },
                child: Text(sandboxList[index].$2)),
          );
        },
      ),
    );
  }
}
