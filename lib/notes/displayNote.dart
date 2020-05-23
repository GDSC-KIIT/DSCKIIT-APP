import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DisplayNote extends StatelessWidget {
  String title;
  String content;
  DisplayNote({this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 10),
        child: ListView(
          children: <Widget>[
            Text(this.title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 35), textAlign: TextAlign.center,),
            SizedBox(height: 30),
            Text(this.content, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 25), textAlign: TextAlign.left,),
          ],
        ),
      )
    );
  }
}
