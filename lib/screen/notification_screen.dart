import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return Scaffold(
        appBar: AppBar(elevation: 0.0,),
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/animator.gif"),
            Text('Coming Soon',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontFamily: "Roboto"))
          ],
        )));
  }
}
