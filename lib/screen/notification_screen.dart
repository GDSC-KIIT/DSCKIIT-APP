import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/animator.gif"),
            Text('Coming Soon', style: TextStyle(color: Color(0xFF183E8D), fontSize: 20.0, fontFamily: "Roboto"))
          ],
        )));
  }
}
