import 'package:flutter/material.dart';
import 'package:sandbox/emoji_firework_animation/emoji_firework_widget.dart';

class EmojiFireworkPage extends StatefulWidget {
  const EmojiFireworkPage({super.key});
  @override
  State<EmojiFireworkPage> createState() => _EmojiFireworkPageState();
}

class _EmojiFireworkPageState extends State<EmojiFireworkPage> {
  EmojiFireWork emojiFireWork =
      EmojiFireWork(emojiAsset: const AssetImage('images/heart_icon.png'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emoji Firework")),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 100,
              child: Container(
                color: Colors.black26,
              ),
            ),
            Container(
              constraints: const BoxConstraints.expand(),
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
                    emojiFireWork.addFireworkWidget(Offset.zero);
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
