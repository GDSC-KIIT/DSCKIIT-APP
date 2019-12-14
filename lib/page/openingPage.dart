import 'package:flutter/material.dart';

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
                //flex: 2,
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
                //flex: 3,
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
                //flex: ,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 30),
                      RaisedButton(
                        onPressed: () {},
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text('Sign Up',
                        style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 30),
                      RaisedButton(
                        onPressed: () {},
                        color: Colors.white,
                        textColor: Colors.black,
                        child: Text('Sign In',
                        style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
