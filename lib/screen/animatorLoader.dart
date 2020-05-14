import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dsckiit_app/page/homePage.dart';
import 'package:dsckiit_app/page/openingPage.dart';

class Loader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoaderState();
}

class _LoaderState extends State<Loader> {
  Timer _timer;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  bool isSignedIn = false;

  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isSignedIn = true;
      });
    }
  }

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "/OpeningPage");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.getUser();
    this.checkAuthentication();
  }

  _LoaderState() {
    _timer = new Timer(const Duration(seconds: 4), () {
      setState(() {});
      Navigator.pushReplacement(
        //<-- Navigate to loginPage on Timeout
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset("assets/animator.gif")),
    );
  }
}
