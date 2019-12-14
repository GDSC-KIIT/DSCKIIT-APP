import 'package:flutter/material.dart';
import 'package:dsckiit_app/page/SignInPage.dart';
import 'package:dsckiit_app/page/welcomePage.dart';

class PasswordDetails extends StatefulWidget {
  @override
  _PasswordDetailsState createState() => _PasswordDetailsState();
}

class _PasswordDetailsState extends State<PasswordDetails> {
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
              Text('Good to have you here. Just one more step.',
                  style: TextStyle(fontSize: 10, fontFamily: 'Roboto')),
              Text('Create a new Password',
                  style: TextStyle(fontSize: 30, fontFamily: 'Roboto')),
              TextFormField(
                obscureText: true,
                decoration: new InputDecoration(
                  hintText: 'Password',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
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
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return WelcomePage();
          }));
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
