import 'package:flutter/material.dart';
import 'package:dsckiit_app/screen/splashScreen.dart';
import 'package:dsckiit_app/page/openingPage.dart';
import 'package:dsckiit_app/page/welcomePage.dart';
import 'package:dsckiit_app/page/SignInPage.dart';
import 'package:dsckiit_app/page/SignUpPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
