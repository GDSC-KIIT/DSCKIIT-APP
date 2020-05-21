import 'package:flutter/material.dart';
import 'package:dsckiit_app/screen/splashScreen.dart';
import 'package:dsckiit_app/page/openingPage.dart';
import 'package:dsckiit_app/page/welcomePage.dart';
import 'package:dsckiit_app/page/SignInPage.dart';
import 'package:dsckiit_app/page/SignUpPage.dart';

import 'screen/splashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xff183E8D),
          fontFamily: 'GoogleSans',
          appBarTheme: AppBarTheme(
              color: Colors.white,
              textTheme: TextTheme(
                  title: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 25)),
              iconTheme: IconThemeData(color: Colors.black))),
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
