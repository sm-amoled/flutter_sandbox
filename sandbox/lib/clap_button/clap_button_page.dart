/// 따라한 예제
/// https://proandroiddev.com/flutter-animation-creating-mediums-clap-animation-in-flutter-3168f047421e

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sandbox/clap_button/clap_button.dart';

enum ScoreWidgetStatus {
  HIDDEN,
  BECOMING_VISIBLE,
  BECOMING_INVISIBLE,
}

class ClapButtonPage extends StatefulWidget {
  const ClapButtonPage({super.key});

  @override
  State<ClapButtonPage> createState() => _ClapButtonPageState();
}

class _ClapButtonPageState extends State<ClapButtonPage>
    with TickerProviderStateMixin {
  late final AnimationController scoreInAnimationController,
      scoreOutAnimationController,
      scoreSizeAnimationController,
      sparkleAnimationController;

  late Animation scoreOutPositionAnimation, sparkleAnimation;

  Timer? holdTimer, scoreOutETA;
  var _scoreWidgetStatue = ScoreWidgetStatus.HIDDEN;

  int _count = 0;
  double _sparklesAngle = 0.0;
  final _duration = const Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    scoreInAnimationController =
        AnimationController(duration: _duration, vsync: this);
    scoreInAnimationController.addListener(() {
      setState(() {});
    });

    scoreOutAnimationController =
        AnimationController(duration: _duration, vsync: this);
    scoreOutPositionAnimation = Tween(begin: 150.0, end: 200.0).animate(
        CurvedAnimation(
            parent: scoreOutAnimationController, curve: Curves.easeOut));
    scoreOutAnimationController.addListener(() {
      setState(() {});
    });
    scoreOutAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scoreWidgetStatue = ScoreWidgetStatus.HIDDEN;
      }
    });

    scoreSizeAnimationController =
        AnimationController(duration: _duration, vsync: this);
    scoreInAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        scoreSizeAnimationController.reverse(from: 0.0);
      }
    });
    scoreSizeAnimationController.addListener(() {
      setState(() {});
    });

    sparkleAnimationController =
        AnimationController(vsync: this, duration: _duration);
    sparkleAnimation = CurvedAnimation(
        parent: sparkleAnimationController, curve: Curves.linear);
    sparkleAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              putScoreButtonWidget(),
              putClapButtonWidget(),
              // sparkleWidget,
            ],
          ),
        ),
      ),
    );
  }

  void _increment() {
    scoreSizeAnimationController.forward(from: 0.0);
    sparkleAnimationController.forward(from: 0.0);
    setState(() {
      _count += 1;
      _sparklesAngle = Random().nextDouble() * (2 * pi);
    });
  }
}

extension _ClapButtonPageStateWidgets on _ClapButtonPageState {
  Widget putScoreButtonWidget() {
    var scorePosition = 0.0;
    var scoreOpacity = 0.0;

    var firstAngle = _sparklesAngle;
    var sparkleRadius = (sparkleAnimationController.value * 100);
    var sparklesOpacity = (1.0 - sparkleAnimation.value);

    List<Widget> stackChildren = [];

    switch (_scoreWidgetStatue) {
      case ScoreWidgetStatus.HIDDEN:
        break;
      case ScoreWidgetStatus.BECOMING_INVISIBLE:
        scorePosition = scoreOutPositionAnimation.value;
        scoreOpacity = 1.0 - scoreOutAnimationController.value;
        break;

      case ScoreWidgetStatus.BECOMING_VISIBLE:
        scorePosition = scoreInAnimationController.value * 150;
        scoreOpacity = scoreInAnimationController.value;
        break;
    }

    for (int idx = 0; idx < 5; idx++) {
      var currentAngle = (firstAngle + ((2 * pi) / 5) * (idx));
      var sparkleWidget = Positioned(
        left: (sparkleRadius * cos(currentAngle)) + 40,
        top: (sparkleRadius * sin(currentAngle)) + 40,
        child: Transform.rotate(
            angle: currentAngle - pi / 2,
            child: Opacity(
              opacity: sparklesOpacity,
              child: Image.asset(
                "images/sparkles.png",
                width: 30.0,
                height: 30.0,
              ),
            )),
      );
      stackChildren.add(sparkleWidget);
    }

    stackChildren.add(
      Opacity(
        opacity: scoreOpacity,
        child: Container(
          width: 100 + scoreSizeAnimationController.value * 20,
          height: 100 + scoreSizeAnimationController.value * 20,
          decoration: const ShapeDecoration(
            shape: CircleBorder(),
            color: Colors.pink,
          ),
          child: Center(
            child: Text(
              '+$_count',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
          ),
        ),
      ),
    );

    return Positioned(
      bottom: scorePosition,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: stackChildren,
      ),
    );
  }

  Widget putClapButtonWidget() {
    return GestureDetector(
      onTapUp: (details) => onTapUp(details),
      onTapDown: (details) => onTapDown(details),
      child: Container(
        width: 100 + scoreSizeAnimationController.value * 20,
        height: 100 + scoreSizeAnimationController.value * 20,
        decoration: const ShapeDecoration(
            color: Colors.white,
            shadows: [BoxShadow(color: Colors.pink, blurRadius: 8.0)],
            shape: CircleBorder()),
        child: const Center(
          child: Image(
            image: AssetImage("images/clap.png"),
            color: Colors.pink,
            width: 70,
            height: 70,
          ),
        ),
      ),
    );
  }
}

extension _ClapButtonPageStateFunctions on _ClapButtonPageState {
  void onTapUp(TapUpDetails tap) {
    scoreOutETA = Timer(_duration, () {
      scoreOutAnimationController.forward(from: 0.0);
      _scoreWidgetStatue = ScoreWidgetStatus.BECOMING_INVISIBLE;
    });
    if (holdTimer != null) {
      holdTimer!.cancel();
    }
  }

  void onTapDown(TapDownDetails tap) {
    if (scoreOutETA != null) {
      scoreOutETA!.cancel();
    }
    if (_scoreWidgetStatue == ScoreWidgetStatus.BECOMING_INVISIBLE) {
      _scoreWidgetStatue = ScoreWidgetStatus.BECOMING_VISIBLE;
    }
    if (_scoreWidgetStatue == ScoreWidgetStatus.HIDDEN) {
      scoreInAnimationController.forward(from: 0.0);
      _scoreWidgetStatue = ScoreWidgetStatus.BECOMING_VISIBLE;
    }
    _increment();
    holdTimer = Timer.periodic(_duration, (timer) => _increment());
  }
}
