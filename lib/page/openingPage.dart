import 'package:dsckiit_app/Widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:dsckiit_app/page/SignUpPage.dart';
import 'package:dsckiit_app/page/SignInPage.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class OpeningPage extends StatefulWidget {
  @override
  _OpeningPageState createState() => _OpeningPageState();
}

class _OpeningPageState extends State<OpeningPage> {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.grey);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 150,
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 20,),
                      Image.asset(
                        'assets/writting.png',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RoundedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                              return SignupPage();
                            }));
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      text: 'Sign up',
                    ),
                    SizedBox(width: 20,),
                    RoundedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                              return SigninPage();
                            }));
                      },
                      color: Colors.grey[50],
                      textColor: Colors.black,
                      text: 'Sign in',
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
