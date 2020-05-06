import 'package:dsckiit_app/constants.dart';
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
        //title: Text("Account", style: AppBarTheme.of(context).textTheme.title.copyWith(fontSize: 30),),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height*0.1,
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              minRadius: 30,
              maxRadius: 60,
              backgroundImage: user.photoUrl == null ? AssetImage('assets/user.png') : NetworkImage(user.photoUrl),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.05,
            ),
            Text(
              user.displayName,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 40),
            ),
            SizedBox(
              //height: MediaQuery.of(context).size.height,
            ),
            Text(user.email, style: TextStyle(fontSize: 20)),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.05,
            ),
            GestureDetector(
              child: Container(
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                  color: kFabColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(child: Text("Sign Out", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                }
            )
          ],
        ),
      ),
    );
  }
}
