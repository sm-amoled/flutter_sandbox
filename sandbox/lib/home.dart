import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sandbox/clap_button/clap_button_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                // Navigator.push(context, CupertinoPageRoute(
                Navigator.push(context, CupertinoPageRoute(
                  builder: (context) {
                    return const ClapButtonPage();
                  },
                ));
              },
              child: const Text("Clap Button"))
        ],
      )),
    );
  }
}
