//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsckiit_app/constants.dart';
import 'package:dsckiit_app/page/media_page.dart';
import 'package:dsckiit_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class AccountPage extends StatefulWidget {
  AccountPage({this.user});

  final FirebaseUser user;

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _db = Firestore.instance;

  List<String> domains = List();

  signOut() async {
    _auth.signOut();
  }

  Future<List<String>> getDomain(FirebaseUser user) async{
    domains = List();
    await _db
        .collection('users')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot) {
      print(DocumentSnapshot.data['domains']);
      DocumentSnapshot.data['domains']
          .forEach((domain) => {domains.add(domain)});
    });
    print(domains);
    return domains;
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Account',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xff183E8D),
      ),
      body: FutureBuilder(
        future: getDomain(widget.user),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return snapshot.data==null? Center(child: CircularProgressIndicator()) : Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.02),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.035,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    minRadius: 30,
                    maxRadius: 60,
                    backgroundImage: widget.user.photoUrl == null
                        ? AssetImage('assets/mascot.png')
                        : NetworkImage(widget.user.photoUrl),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  CustomContainer(
                    icon: Icons.person,
                    title: "Name",
                    height: MediaQuery.of(context).size.height * 0.1,
                    widget: Text(
                      widget.user.displayName,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.035,
                  ),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Icon(
                              Icons.info_outline,
                              size: 30,
                              color: primaryColor,
                            ),
                            Expanded(
                              child: Container(),
                            )
                          ],
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Domains',
                                style:
                                TextStyle(color: Colors.grey, fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.8,
                              height: 50,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: domains.length,
                                  itemBuilder: (context, int index) {
                                    return Row(
                                      children: <Widget>[
                                        DomainContainer(title: domains[index]),
                                        SizedBox(width: 10,),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  CustomContainer(
                    icon: Icons.mail,
                    title: "Email id",
                    height: MediaQuery.of(context).size.height * 0.1,
                    widget: Text(widget.user.email,
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  GestureDetector(
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: kFabColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                            child: Text("Sign Out",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                      ),
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                      })
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  CustomContainer({this.icon, this.title, this.widget, this.height});

  final icon;
  String title;
  Widget widget;
  final height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Icon(
                icon,
                size: 30,
                color: primaryColor,
              ),
              Expanded(
                child: Container(),
              )
            ],
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: TextStyle(color: Colors.grey, fontSize: 20)),
              SizedBox(
                height: 10,
              ),
              widget,
            ],
          ),
        ],
      ),
    );
  }
}

class DomainContainer extends StatelessWidget {
  DomainContainer({this.title});

  String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.grey[600], fontSize: 18),
          ),
          IconButton(
            icon: Icon(Icons.adjust),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
