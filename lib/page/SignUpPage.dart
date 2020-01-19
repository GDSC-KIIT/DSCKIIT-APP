import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class SignupPage extends StatefulWidget {
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final db = Firestore.instance;

  String _name, _email, _password;

  void createRecord(String email, String name, String uid) {
      db.collection("count").document("userCount").get().then((DocumentSnapshot snapshot) async {
      int usercount = snapshot['count'] + 1;
      db.collection("count").document("userCount").updateData({'count': usercount});
      // print(usercount);
      String x = 'user $usercount';
      await db.collection("users").document(x).setData({
        'userId': uid,
        'email': email,
        'name': name,
        'admin': "no"
        });
    });
  }

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "/WelcomePage");
      }
    });
  }

  navigateToSignInPage() {
    Navigator.pushReplacementNamed(context, "/SigninPage");
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  signup() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
                email: _email, password: _password))
            .user;
        if (user != null) {
          UserUpdateInfo updateuser = UserUpdateInfo();
          updateuser.displayName = _name;
          user.updateProfile(updateuser);
          this.createRecord(_email, _name, user.uid);
        }
      } catch (e) {
        showError(e.message);
      }
    }
  }

  showError(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //FlutterStatusbarcolor.setStatusBarColor(Colors.grey);
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        //backgroundColor: Colors.white,
        title: Text(
          'Sign Up',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
                child: Image(
                  image: AssetImage("assets/logo.png"),
                  width: 100.0,
                  height: 100.0,
                ),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      //Name text Box
                      Container(
                        padding: EdgeInsets.only(top: 5.0),
                        child: TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Provide your real Name';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(color: Colors.blue)),
                            //labelStyle: new TextStyle(color: Colors.blue),
                          ),
                          onSaved: (input) => _name = input,
                        ),
                      ),
                      //E-mail Text box
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Provide an E-mail.';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(color: Colors.blue)),
                            //labelStyle: new TextStyle(color: Colors.blue),
                          ),
                          onSaved: (input) => _email = input,
                        ),
                      ),
                      //Password Text Box
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: TextFormField(
                          validator: (input) {
                            if (input.length < 6) {
                              return 'Provide a Password which should have 6 character atleast.';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(color: Colors.blue)),
                            //labelStyle: new TextStyle(color: Colors.blue),
                          ),
                          onSaved: (input) => _password = input,
                          obscureText: true,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 20.0, 0.0, 15.0),
                        child: RaisedButton(
                          padding:
                              EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          onPressed: signup,
                          child: Text(
                            'Sign Up',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: navigateToSignInPage,
                        child: Text(
                          'Already have an account? Sign In',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
