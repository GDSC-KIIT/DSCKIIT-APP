import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dsckiit_app/page/homePage.dart';


class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;
  bool isSignedIn = false;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "/SigninPage");
      }
    });
  }

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

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: !isSignedIn
              ? CircularProgressIndicator()
              : Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(50.0),
                      child: Image(
                        image: AssetImage("assets/logo.png"),
                        width: 100.0,
                        height: 100.0,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(50.0),
                      child: Text(
                        'Welcome! ${user.displayName}, you are logged in as ${user.email}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: RaisedButton(
                        color: Colors.blue,
                        padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
                            return HomePage();
                          }));
                        },
                        child: Text('Get Started',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0)),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
