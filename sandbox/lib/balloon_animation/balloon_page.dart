import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sandbox/balloon_animation/balloon_model.dart';
import 'package:sandbox/emoji_firework_animation/emoji_firework_widget.dart';

class BalloonPage extends ConsumerStatefulWidget {
  BalloonPage({super.key});
  @override
  ConsumerState<BalloonPage> createState() => _BalloonPageState();
}

class _BalloonPageState extends ConsumerState<BalloonPage> {
  late Map<Key, BalloonWidget> _balloonWidgets;
  late BalloonManager _balloonManager;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _balloonWidgets = ref.watch(balloonManagerProvider);
    _balloonManager = ref.read(balloonManagerProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    _balloonWidgets = ref.watch(balloonManagerProvider);

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
            Container(
              constraints: BoxConstraints.expand(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Stack(
                    children: _balloonWidgets.values.toList(),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _balloonManager.addBalloon();
                  });
                },
                child: const Text("Tap Button"),
              ),
            ),
            Positioned(
              bottom: 0,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {});
                  print(_balloonWidgets);
                },
                child: Text(_balloonWidgets.length.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
