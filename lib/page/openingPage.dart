import 'package:flutter/material.dart';
import 'package:dsckiit_app/page/SignUpPage.dart';
import 'package:dsckiit_app/page/SignInPage.dart';

class OpeningPage extends StatefulWidget {
  @override
  _OpeningPageState createState() => _OpeningPageState();
}

class _OpeningPageState extends State<OpeningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                //flex: 1,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/logo.png',
                        width: 150,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                //flex: 1,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/writting.png',
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 100.0, 0.0),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  //flex: 1,
                  child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                            return SignupPage();
                          }));
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text('Sign up'),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                            return SigninPage();
                          }));
                        },
                        color: Colors.white,
                        textColor: Colors.black,
                        child: Text('Sign in'),
                      ),
                    ],
                  )
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}
