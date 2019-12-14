import 'package:dsckiit_app/page/SignInPage.dart';
import 'package:flutter/material.dart';
import 'package:dsckiit_app/page/nameDetails.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 40, 0, 0),
        child: Form(
          child: ListView(
            children: <Widget>[
              Text(
                'Enter your KIIT roll number',
                style: TextStyle(fontSize: 30, fontFamily: 'Roboto')
              ),
              TextFormField(
                decoration: new InputDecoration(
                  hintText: 'Roll No',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context){
                              return SignIn();
                            }));
                },
                child: Text(
                  'Already have an account ? Sign In',
                  textAlign: TextAlign.start,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context){
                              return NameDetails();
                            })); 
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}

