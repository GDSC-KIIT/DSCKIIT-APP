import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  AccountPage({this.user});

  final FirebaseUser user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  signOut() async {
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff183E8D),
        title: Text("Account"),
        centerTitle: true,
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
              child: Image.network(user.photoUrl),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              user.displayName,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 40),
            ),
            SizedBox(
              //height: MediaQuery.of(context).size.height,
            ),
            Text(user.email, style: TextStyle(fontSize: 20)),
            RaisedButton(
              color: Color(0xff183E8D),
                child: Text("Sign Out"),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                })
          ],
        ),
      ),
    );
  }
}
