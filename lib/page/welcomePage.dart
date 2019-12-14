import 'package:dsckiit_app/page/homePage.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(250,150,0,0),
            child: Image.asset(
              'assets/logo.png',
            alignment: Alignment.bottomLeft,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 145, 60, 0),
            child: Image.asset(
            'assets/welcome.png'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Image.asset(
            'assets/collab.png'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
            child: Image.asset(
            'assets/events.png'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(55, 220, 0, 0),
            child: RaisedButton(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context){
                              return HomePage();
                            }));
              },
              color: Colors.blue,
              textColor: Colors.white,
              child: Text(
                'GET STARTED',
                style: TextStyle(fontSize: 20,
              ),
            ),
          ),
          )
        ],
      ),
    ));
  }
}
