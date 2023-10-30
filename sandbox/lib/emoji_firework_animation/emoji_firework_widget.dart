import 'dart:math';

import 'package:flutter/material.dart';

class FireworkWidget extends StatefulWidget {
  FireworkWidget({super.key, required this.notifyWidgetIsDisposed});
  Function notifyWidgetIsDisposed;
  @override
  State<FireworkWidget> createState() => _FireworkWidgetState();
}

class _FireworkWidgetState extends State<FireworkWidget>
    with TickerProviderStateMixin {
  late List<EmojiWidget> emojiWidgetList;
  late final AnimationController emojiAnimationShootController,
      emojiAnimationFloatController,
      emojiAnimationLifeTimeController;
  late final Animation<double> emojiShootAnimation,
      emojiFloatYAnimation,
      emojiFloatXAnimation,
      emojiLifeTimeAnimation;
  late Duration _emojiLifetimeDuration = Duration(seconds: 5);
  late Duration _emojiShootDuration = Duration(seconds: 2);

  void startAnimation() {
    emojiAnimationShootController.forward(from: 0.0);
    emojiAnimationFloatController.forward(from: 0.0);
    emojiAnimationLifeTimeController.forward(from: 0.0);
  }

  @override
  void initState() {
    super.initState();

    emojiAnimationShootController = AnimationController(
      vsync: this,
      duration: _emojiShootDuration,
    );
    emojiAnimationFloatController = AnimationController(
        vsync: this,
        duration: Duration(seconds: _emojiLifetimeDuration.inSeconds));
    // 이모지 퍼트리기
    emojiShootAnimation = Tween(begin: 0.0, end: 100.0).animate(CurvedAnimation(
      parent: emojiAnimationShootController,
      curve: Curves.easeOut,
    ));
    emojiShootAnimation.addListener(() {
      setState(() {});
    });

    // 이모지 둥둥s
    emojiFloatXAnimation = Tween(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
        parent: emojiAnimationFloatController,
        curve: Curves.linear,
      ),
    );
    emojiFloatXAnimation.addListener(() {
      setState(() {});
    });
    emojiFloatYAnimation = Tween(begin: -50.0, end: 1000.0).animate(
      CurvedAnimation(
        parent: emojiAnimationFloatController,
        curve: Curves.easeIn,
      ),
    );
    emojiFloatYAnimation.addListener(() {
      setState(() {});
    });

    emojiAnimationLifeTimeController =
        AnimationController(vsync: this, duration: _emojiLifetimeDuration);
    emojiLifeTimeAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: emojiAnimationLifeTimeController, curve: Curves.linear));
    emojiLifeTimeAnimation.addListener(() {
      setState(() {});
    });
    emojiLifeTimeAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // dispose();
        widget.notifyWidgetIsDisposed(widget.key);
      }
    });

    emojiWidgetList = List.generate(
      50,
      (index) => EmojiWidget(
        emojiFloatXAnimation: emojiFloatXAnimation,
        emojiFloatYAnimation: emojiFloatYAnimation,
        emojiShootAnimation: emojiShootAnimation,
        emojiLifeTimeAnimation: emojiLifeTimeAnimation,
      ),
    );

    startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: List.generate(
          25,
          (index) => EmojiWidget(
            emojiFloatXAnimation: emojiFloatXAnimation,
            emojiFloatYAnimation: emojiFloatYAnimation,
            emojiShootAnimation: emojiShootAnimation,
            emojiLifeTimeAnimation: emojiLifeTimeAnimation,
          ),
        ),
      ),
    );
  }
}

class EmojiWidget extends StatefulWidget {
  const EmojiWidget({
    required this.emojiShootAnimation,
    required this.emojiFloatYAnimation,
    required this.emojiFloatXAnimation,
    required this.emojiLifeTimeAnimation,
  });

  final Animation<double> emojiShootAnimation,
      emojiFloatYAnimation,
      emojiFloatXAnimation,
      emojiLifeTimeAnimation;

  @override
  State<EmojiWidget> createState() => EmojiWidgetState();
}

class EmojiWidgetState extends State<EmojiWidget> {
  late double xScale, yScale, distinctiveRandomSeed;

  @override
  void initState() {
    super.initState();

    xScale = Random().nextDouble() * 2 - 1;
    yScale = Random().nextDouble() * 2 - 1;
    distinctiveRandomSeed = Random().nextDouble();
  }

  @override
  Widget build(BuildContext context) {
    var emojiAnimationShootX = widget.emojiShootAnimation.value * 3 * xScale;
    var emojiAnimationShootY = widget.emojiShootAnimation.value * 5 * yScale;

    var emojiAnimationFloatX =
        sin(widget.emojiFloatXAnimation.value + distinctiveRandomSeed) * 20;
    var emojiAnimationFloatY = widget.emojiFloatYAnimation.value < 0
        ? 0
        : widget.emojiFloatYAnimation.value * -1;

    var emojiAnimationPositionX = emojiAnimationShootX + emojiAnimationFloatX;
    var emojiAnimationPositionY = emojiAnimationShootY + emojiAnimationFloatY;

    var emojiScale = sin(
                (widget.emojiLifeTimeAnimation.value + distinctiveRandomSeed) *
                    10) *
            0.3 +
        1;
    bool isEmojiTransparent =
        (widget.emojiLifeTimeAnimation.value + distinctiveRandomSeed) > 1.8;

    return Positioned(
      left: emojiAnimationPositionX,
      top: emojiAnimationPositionY,
      child: Opacity(
        opacity: isEmojiTransparent ? 0.0 : 1.0,
        child: Image(
          image: const AssetImage("images/heart_icon.png"),
          width: 40 * emojiScale,
          height: 40 * emojiScale,
        ),
      ),
    );
  }
}
