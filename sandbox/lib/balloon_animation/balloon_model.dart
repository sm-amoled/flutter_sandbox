import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

final balloonManagerProvider =
    StateNotifierProvider<BalloonManager, Map<Key, BalloonWidget>>(
  (ref) {
    return BalloonManager();
  },
);

class BalloonManager extends StateNotifier<Map<Key, BalloonWidget>> {
  BalloonManager() : super({});

  void addBalloon() {
    final balloonWidgetKey = UniqueKey();

    state.addEntries(<Key, BalloonWidget>{
      balloonWidgetKey: BalloonWidget(
        key: balloonWidgetKey,
        notifyWidgetIsDisposed: (Key widgetKey) {
          state.remove(widgetKey);
        },
      ),
    }.entries);
  }
}

class BalloonWidget extends StatefulWidget {
  BalloonWidget({
    required this.key,
    required this.notifyWidgetIsDisposed,
  });
  @override
  Key key;
  Function notifyWidgetIsDisposed;

  @override
  State<BalloonWidget> createState() => _BalloonWidgetState();
}

class _BalloonWidgetState extends State<BalloonWidget>
    with TickerProviderStateMixin {
  // animation variables
  late AnimationController _animationController;
  late Animation _animation;

  late Timer _timer;
  double wind = 0.1;
  double speed = 0.1;

  late Balloon balloonModel;

  late final double width;
  late final double height;

  @override
  void initState() {
    super.initState();

    // 불꽃놀이 위젯 자체의 지속시간과 관련된 Animation 관련 값 초기화
    // 여기에서 이모지 크기를 조정할 수 있는 값을 제공한다.
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // widget.notifyWidgetIsDisposed();
        _animationController.repeat();
      }
    });
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    balloonModel = Balloon(
      x: Random().nextDouble() * width,
      y: Random().nextDouble() * height,
      windDirection: Random().nextBool() ? 1 : -1,
    );

    _startAnimation();
  }

  _startAnimation() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BalloonParticle(
      x: balloonModel.x + 50 * sin(_animation.value),
      y: balloonModel.y + 25 * cos(_animation.value),
      notifyWidgetIsDisposed: notifyWidgetIsDisposed,
    );
  }

  void notifyWidgetIsDisposed() {
    print("DISPISING");
    _animationController.dispose();
    widget.notifyWidgetIsDisposed(widget.key);
    super.dispose();
  }
}

class BalloonParticle extends StatelessWidget {
  Function notifyWidgetIsDisposed;
  BalloonParticle({
    super.key,
    required this.x,
    required this.y,
    required this.notifyWidgetIsDisposed,
  });

  double x;
  double y;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTapUp: (details) {
          notifyWidgetIsDisposed();
        },
        child: Container(
          width: 130,
          height: 130,
          decoration: const BoxDecoration(
            color: Colors.amber,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class Balloon {
  double x;
  double y;
  final int windDirection;

  Balloon({
    required this.x,
    required this.y,
    required this.windDirection,
  });
}
