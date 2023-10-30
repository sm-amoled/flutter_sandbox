import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sandbox/emoji_firework_animation/emoji_firework_widget.dart';

class EmojiFireworkPage extends StatefulWidget {
  EmojiFireworkPage({super.key});
  late Map<Key, FireworkWidget> fireworkWidgets = {};
  @override
  State<EmojiFireworkPage> createState() => _EmojiFireworkPageState();
}

class _EmojiFireworkPageState extends State<EmojiFireworkPage>
    with TickerProviderStateMixin {
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
                    children: widget.fireworkWidgets.values.toList(),
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
                  setFireworkWidget();
                  print(widget.fireworkWidgets.length);
                },
                child: const Text("Tap Button"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setFireworkWidget() {
    setState(() {
      final fireworkWidgetKey = UniqueKey();
      // widget.fireworkWidgetList.add(FireworkWidget(key: fireworkWidgetKey));
      widget.fireworkWidgets.addEntries(<Key, FireworkWidget>{
        fireworkWidgetKey: FireworkWidget(
          key: fireworkWidgetKey,
          notifyWidgetIsDisposed: notifyWidgetIsDisposed,
        )
      }.entries);
    });
  }

  void notifyWidgetIsDisposed(Key widgetKey) {
    widget.fireworkWidgets.remove(widgetKey);
  }
}
