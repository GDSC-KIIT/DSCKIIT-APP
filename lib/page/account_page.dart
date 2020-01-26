import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  AccountPage({this.user});

  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent[200],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              minRadius: 30,
              child: Image.network(
                  "https://static.thenounproject.com/png/17241-200.png"),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "User name",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 40),
            ),
            SizedBox(
              height: 20,
            ),
            Text("User email", style: TextStyle(fontSize: 20))
          ],
        ),
      ),
    );
  }
}
