import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sandbox/emoji_firework_animation/emoji_firework_widget.dart';

class EmojiFireworkPage extends StatefulWidget {
  EmojiFireworkPage({super.key});
  @override
  State<EmojiFireworkPage> createState() => _EmojiFireworkPageState();
}

class _EmojiFireworkPageState extends State<EmojiFireworkPage> {
  EmojiFireWork emojiFireWork =
      EmojiFireWork(emojiAsset: const AssetImage('images/heart_icon.png'));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emoji Firework")),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 100,
              child: Container(
                color: Colors.black26,
              ),
            ),
            Positioned(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Stack(
                    children: emojiFireWork.fireworkWidgets.values.toList(),
                  ),
                  const Text(
                    "💣",
                    style: TextStyle(fontSize: 60),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    emojiFireWork.addFireworkWidget();
                  });
                },
                child: const Text("Tap Button"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
