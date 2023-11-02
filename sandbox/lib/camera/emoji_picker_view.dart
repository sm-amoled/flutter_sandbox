import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmojiPickerView extends StatefulWidget {
  const EmojiPickerView({super.key});

  @override
  State<EmojiPickerView> createState() => _EmojiPickerViewState();
}

class _EmojiPickerViewState extends State<EmojiPickerView> {
  Map<Key, ShootEmojiWidget> widgets = {};

  int countSend = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emoji Picker")),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTapUp: (details) => showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  clipBehavior: Clip.none,
                  elevation: 0,
                  context: context,
                  builder: (context) {
                    void disposeWidget(UniqueKey key) {
                      setState(() {
                        widgets.remove(key);
                      });
                    }

                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Stack(
                            alignment: Alignment.topCenter,
                            clipBehavior: Clip.none,
                            children: widgets.values.toList(),
                          ),
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 30.0),
                                child: Text("반응을 $countSend 회 보냈어요!",
                                    style: TextStyle(fontSize: 20)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                    children: List<Widget>.generate(
                                  3,
                                  (index) => Row(
                                    children: List<Widget>.generate(5, (index) {
                                      final key = GlobalKey();
                                      return Expanded(
                                        key: key,
                                        flex: 1,
                                        child: GestureDetector(
                                          onTapDown: (detail) {},
                                          onTapUp: (detail) {
                                            setState(
                                              () {
                                                countSend++;
                                                final animationWidgetKey =
                                                    UniqueKey();
                                                widgets.addEntries({
                                                  animationWidgetKey: ShootEmojiWidget(
                                                      key: animationWidgetKey,
                                                      currentPos: Point(
                                                          detail.globalPosition
                                                              .dx,
                                                          detail.globalPosition
                                                              .dy),
                                                      targetPos: Point(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height +
                                                              50),
                                                      disposeWidgetFromParent:
                                                          disposeWidget)
                                                }.entries);
                                              },
                                            );
                                            print(widgets.length);
                                          },
                                          // },
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                    "images/sample_emoji.png"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                )),
                              ),
                              SizedBox(
                                height: 60,
                              )
                            ],
                          ),
                        ],
                      );
                    });
                  }).whenComplete(() => widgets.clear()),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.limeAccent,
                    border: Border.all(width: 3)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShootEmojiWidget extends StatefulWidget {
  ShootEmojiWidget(
      {super.key,
      required this.disposeWidgetFromParent,
      required this.currentPos,
      required this.targetPos});
  Function disposeWidgetFromParent;
  Point currentPos;
  Point targetPos;

  @override
  State<ShootEmojiWidget> createState() => _ShootEmojiWidgetState();
}

class _ShootEmojiWidgetState extends State<ShootEmojiWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late var _yAnimation, _xAnimation;
  late Function disposeWidgetFromParent;
  late double targetXPos;
  final double emojiSize = 50;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    disposeWidgetFromParent = widget.disposeWidgetFromParent;

    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _yAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _xAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    // _animation = Tween<double>(begin: 0, end: 1).animate(_controller, );
    _controller.forward(from: 0.0);
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        disposeWidgetFromParent(widget.key);
        // dispose();
        // super.dispose();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: (widget.targetPos.y * 1.0 * _yAnimation.value) +
          (400) * (1 - _yAnimation.value),
      left: widget.targetPos.x.toDouble() * _xAnimation.value +
          (widget.currentPos.x.toDouble()) * (1 - _xAnimation.value) -
          emojiSize / 2,
      child: Image(
        width: emojiSize,
        height: emojiSize,
        image: AssetImage("images/heart_icon.png"),
      ),
    );
  }
}
