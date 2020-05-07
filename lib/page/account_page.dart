import 'package:dsckiit_app/constants.dart';
import 'package:dsckiit_app/page/media_page.dart';
import 'package:dsckiit_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:line_icons/line_icons.dart';

class AccountPage extends StatelessWidget {
  AccountPage({this.user});

  final FirebaseUser user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  signOut() async {
    _auth.signOut();
  }

  List<String> _titles = ['Design', 'Machine Learning', 'Web Developer', 'Content Writing', 'Marketing', 'Flutter', 'Cloud and Network Security', 'Photography and Videography', 'Actions on Google', '3D Modelling'];

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
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.08,
            vertical: 0.0),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  minRadius: 30,
                  maxRadius: 60,
                  backgroundImage: user.photoUrl == null
                      ? AssetImage('assets/user.png')
                      : NetworkImage(user.photoUrl),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                CustomContainer(
                  icon: Icons.person,
                  title: "Name",
                  height: MediaQuery.of(context).size.height * 0.1,
                  widget: Text(
                    user.displayName,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                CustomContainer(
                  icon: Icons.info_outline,
                  title: "Domains",
                  widget: DomainContainer(title: "Flutter"),
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                CustomContainer(
                  icon: Icons.mail,
                  title: "Email id",
                  height: MediaQuery.of(context).size.height * 0.1,
                  widget: Text(user.email,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
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
        ),
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
          SizedBox(width: 10,),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 18),),
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: (){},
          )
        ],
      ),
    );
  }
}

