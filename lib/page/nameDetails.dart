import 'package:flutter/material.dart';
import 'package:dsckiit_app/page/SignInPage.dart';
import 'package:dsckiit_app/page/passwordPage.dart';


class NameDetails extends StatefulWidget {
  @override
  _NameDetailsState createState() => _NameDetailsState();
}

class _NameDetailsState extends State<NameDetails> {

  String _name;

  TextEditingController userNameController = TextEditingController();
  //_NameDetailsState({Key key, this.title}) : super(key: key);

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
                'What should we call you?',
                style: TextStyle(fontSize: 30, fontFamily: 'Roboto')
              ),
              TextFormField(
                decoration: new InputDecoration(
                  hintText: 'First Name',
                ),
                controller: userNameController,
                //onSaved: (input) => _name = input,
              ),
              
              TextFormField(
                decoration: new InputDecoration(
                  hintText: 'Last Name',
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
                              return PasswordDetails();
                            })); 
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}

