import 'package:flutter/material.dart';
import 'package:dsckiit_app/screen/splashScreen.dart';
import 'package:dsckiit_app/page/openingPage.dart';
import 'package:dsckiit_app/page/welcomePage.dart';
import 'package:dsckiit_app/page/SignInPage.dart';
import 'package:dsckiit_app/page/SignUpPage.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:dsckiit_app/page/animationLoader.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        "/SigninPage": (BuildContext context) => SigninPage(),
        "/SignupPage": (BuildContext context) => SignupPage(),
        "/OpeningPage": (BuildContext context) => OpeningPage(),
        "/WelcomePage": (BuildContext context) => WelcomePage(),
      },
    );
  }
}
