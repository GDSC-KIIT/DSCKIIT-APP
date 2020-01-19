import 'package:dsckiit_app/page/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  CurvedAnimation _iconAnimation;

  void handleTimeOut() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => new HomePage()));
  }

  startTimeout() async {
    var duration = const Duration(seconds: 3);
    return new Timer(duration, handleTimeOut);
  }

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
        vsync: this, duration: new Duration(milliseconds: 2200));
    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.easeIn);
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('assets/dsckiitLogo.png',),
              //fit: BoxFit.
            ),
          ),
        ),
      ),
    );
  }
}
