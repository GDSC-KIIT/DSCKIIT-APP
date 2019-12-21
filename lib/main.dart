import 'package:floating_search_bar/floating_search_bar.dart';
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
      // home: FloatingSearchBar.builder(
      //           itemCount: 100,
      //           itemBuilder: (BuildContext context, int index) {
      //             return ListTile(
      //               leading: Text(index.toString()),
      //             );
      //           },
      //           trailing: CircleAvatar(
      //             child: Text("RD"),
      //           ),
      //           drawer: Drawer(
      //             child: Container(),
      //           ),
      //           onChanged: (String value) {},
      //           onTap: () {},
      //           decoration: InputDecoration.collapsed(
      //             hintText: "Search...",
      //           ),
      //         ),
      routes: <String, WidgetBuilder>{
        "/SigninPage": (BuildContext context) => SigninPage(),
        "/SignupPage": (BuildContext context) => SignupPage(),
        "/OpeningPage": (BuildContext context) => OpeningPage(),
        "/WelcomePage": (BuildContext context) => WelcomePage(),
      },
    );
  }
}
