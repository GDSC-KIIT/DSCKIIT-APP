import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dsckiit_app/Widgets/custom_card.dart';
import 'package:dsckiit_app/Widgets/custom_event_card.dart';
import 'package:dsckiit_app/constants.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;
  bool isSignedIn = false;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "/OpeningPage");
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
      backgroundColor: Colors.white,
      body: FloatingSearchBar.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Ongoing",
                          style: kHeadingStyle,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Colors.grey[900],
                          ),
                          iconSize: 27,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 150,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, int index) {
                        return CustomCard(
                          title: 'Some title project',
                          members: index + 1,
                          color: Colors.indigo,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Events and Schedules",
                          style: kHeadingStyle,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Colors.grey[900],
                          ),
                          iconSize: 27,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 150,
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          Firestore.instance.collection('events').snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return new Text('Loading...');
                          default:
                            return new ListView(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data.documents
                                  .map((DocumentSnapshot document) {
                                return new CustomEventCard(
                                  title: document['title'],
                                  imgURL: document['image'],
                                  date: document['date'],
                                );
                              }).toList(),
                            );
                        }
                      },
                    ),
                    // child: ListView.builder(
                    //   physics: BouncingScrollPhysics(),
                    //   shrinkWrap: true,
                    //   scrollDirection: Axis.horizontal,
                    //   itemCount: 10,
                    //   itemBuilder: (context, int index) {
                    //     return CustomEventCard(
                    //       title: 'Sample title',
                    //       imgURL:
                    //           'https://www.invensis.net/blog/wp-content/uploads/2015/05/Benefits-of-Python-over-other-programming-languages-invensis.jpg',
                    //       date: '31st October',
                    //     );
                    //   },
                    // ),
                  ),
                ],
              ),
            ),
          );
        },
        trailing: CircleAvatar(
          backgroundImage:
              NetworkImage('https://learncodeonline.in/mascot.png'),
          //backgroundImage: NetworkImage(user.photoUrl),
          backgroundColor: Colors.transparent,
          //child: Text("RD"),
        ),
        drawer: Drawer(
          child: Container(),
        ),
        onChanged: (String value) {},
        onTap: () {},
        decoration: InputDecoration.collapsed(
          hintText: "Search events, people etc.",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
      ),
    );
  }
}
