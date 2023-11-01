import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmojiPickerView extends StatelessWidget {
  const EmojiPickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emoji Picker")),
      body: Center(
        child: GestureDetector(
          onTapUp: (details) => showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30.0),
                      child: Text("반응을 NN 회 보냈어요!",
                          style: TextStyle(fontSize: 20)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                          children: List<Widget>.generate(
                        3,
                        (index) => Row(
                          children: List<Widget>.generate(
                            5,
                            (index) => Expanded(
                              flex: 1,
                              child: GestureDetector(
                                child: Image(
                                    image:
                                        AssetImage("images/sample_emoji.png")),
                              ),
                            ),
                          ),
                        ),
                      )),
                    ),
                    ListTile(
                        // leading: new Icon(Icons.share),
                        // title: new Text('Share'),
                        // onTap: () {
                        //   Navigator.pop(context);
                        // },
                        ),
                  ],
                );
              }),
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
    );
  }
}
