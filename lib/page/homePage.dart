import 'package:dsckiit_app/page/chatPage.dart';
import 'package:dsckiit_app/page/chat_container.dart';
import 'package:dsckiit_app/page/media_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dsckiit_app/Widgets/custom_card.dart';
import 'package:dsckiit_app/Widgets/custom_event_card.dart';
import 'package:dsckiit_app/constants.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:dsckiit_app/page/account_page.dart';

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
    FlutterStatusbarcolor.setStatusBarColor(Colors.grey);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 14.0),
        child: FloatingSearchBar.builder(
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
                        itemCount: 3,
                        itemBuilder: (context, int index) {
                          return CustomCard(
                            title: 'American Sign Language Recognition',
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
                              return Center(child: CircularProgressIndicator());
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
                                    registerUrl: document['register'],
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
          trailing: !isSignedIn
              ? CircleAvatar(
                  backgroundImage: AssetImage("assets/animator.gif"),
                  backgroundColor: Colors.transparent,
                )
              : CircleAvatar(
                  backgroundImage: user!=null ? user.photoUrl!=null ? NetworkImage(user.photoUrl) : AssetImage('assets/user.png') : AssetImage('assets/user.png'),
                  backgroundColor: Colors.transparent,
                ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/mascot.png',
                        ),
                        fit: BoxFit.cover,
                      )),
                  //child: Text('Header'),
                ),
                ListTile(
                  title: Text("Accounts"),
                  trailing: Icon(Icons.person),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountPage(user: user)));
                  },
                ),
                ListTile(
                  title: Text("Chat"),
                  trailing: Icon(Icons.message),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ChatContainer();
                    }));
                  },
                ),
                ListTile(
                  title: Text("Noticeboard"),
                  trailing: Icon(Icons.photo),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MediaPage()));
                  },
                ),
                ListTile(
                  title: Text("Feedback From"),
                  trailing: Icon(Icons.feedback),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  title: Text("Close"),
                  trailing: Icon(Icons.close),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          onChanged: (String value) {},
          onTap: () {},
          decoration: InputDecoration.collapsed(
            hintText: "Search events, people etc.",
          ),
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
