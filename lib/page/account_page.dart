import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff183E8D),
        title: Text("Account"),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              minRadius: 30,
              maxRadius: 60,
              child: user.photoUrl == null ? Image.asset('assets/user.png', fit: BoxFit.fill,) : Image.network(user.photoUrl),
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
            SizedBox(height: 20,),
            RaisedButton(
              color: Color(0xff183E8D),
                child: Text("Sign Out", style: TextStyle(color: Colors.white),),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                })
          ],
        ),
      ),
    );
  }
}
