import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsckiit_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'group_creator.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class GroupsList extends StatefulWidget {
  @override
  _GroupsListState createState() => _GroupsListState();
  final bool joined;
  final String name,uid;
  GroupsList({Key key,this.joined,this.name,this.uid}) : super(key:key);
}

class _GroupsListState extends State<GroupsList> {
  String category,name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => new CreateGroup(uid: widget.uid)
                ),
              ),
          backgroundColor: primaryColor,
          child: Icon(Icons.add),
        ),
      body: FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context,AsyncSnapshot<FirebaseUser> snapshot){
          if (snapshot.hasData) {
            FirebaseUser user = snapshot.data;
            name = user.displayName;
          }
          return StreamBuilder<QuerySnapshot>(
            stream: widget.joined ? Firestore.instance.collection('groups').where('members',arrayContains: widget.uid).snapshots() : Firestore.instance.collection('groups').snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Center(child: new Text('Loading...'));
                default:
                  return Container(
                    color: Colors.white,
                    child: (widget.joined) ? ListView(
                        children: snapshot.data.documents.map((
                            DocumentSnapshot document) {
                          return new GestureDetector(
                            onTap: widget.joined ? () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => new ChatPage(to: null,from: widget.uid,url: document['image_url'],name: name,groupId: document.documentID,groupName: document['name'])));
                            } : () => showDialog(context: _scaffoldKey.currentContext,
                                builder: (
                                    BuildContext context) {
                                  return AlertDialog(
                                    title: new Text(
                                        "Are you Sure you want join this Group?"),
                                    actions: <Widget>[
                                      new FlatButton(
                                          onPressed: () =>
                                              Navigator.of(
                                                  context)
                                                  .pop(),
                                          child: new Text(
                                              "No")),
                                      new FlatButton(
                                          onPressed: () {
                                            final DocumentReference postRef = Firestore
                                                .instance.collection(
                                                "groups")
                                                .document(
                                                document.documentID);
                                            Firestore.instance
                                                .runTransaction((
                                                Transaction tx) async {
                                              DocumentSnapshot postSnapshot = await tx
                                                  .get(postRef);
                                              if (postSnapshot.exists) {
                                                await tx.update(postRef,
                                                    <String, dynamic>{
                                                      'members': FieldValue.arrayUnion([widget.uid]),
                                                    });
                                              }
                                            });
                                            Navigator.of(
                                                context).pop();
                                          }, child: new Text(
                                          "Yes"))
                                    ],
                                  );
                                }),
                            child: Container(
                              color: Colors.white,
                              margin: EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          margin: EdgeInsets.only(right: 4.0),
                                          height: 70.0,
                                          width: 70.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(document['image_url']),
                                              fit: BoxFit.cover,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10.0,bottom: 5),
                                            child: new Text(document['name'],style: TextStyle(fontWeight: FontWeight.bold),),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 5.0,bottom: 10),
                                            child: new Text('last message'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 1.5,
                                    indent: 8.0,
                                    endIndent: 8.0,
                                    color: Color(0xffE2E2E2),
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList()
                    ) : new Container(
                      color: Colors.white,
                      child: Container(
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/50,right:  MediaQuery.of(context).size.width/50),
                        child: new CustomScrollView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverPadding(
                              padding: const EdgeInsets.only(top: 10,left: 10),
                              sliver: SliverGrid.count(
                                  mainAxisSpacing: 1, //horizontal space
                                  crossAxisSpacing: 0, //vertical space
                                  crossAxisCount: 2, //number of images for a row
                                  children: snapshot.data.documents.map((
                                      DocumentSnapshot document) {
                                    return new GestureDetector(
                                      onTap: document['members'].contains(widget.uid) ? () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => new ChatPage(to: null,from: widget.uid,url: document['image_url'],groupId: document.documentID,name: name,groupName: document['name'])));
                                      } : () => showDialog(context: _scaffoldKey.currentContext,
                                          builder: (
                                              BuildContext context) {
                                            return AlertDialog(
                                              title: new Text(
                                                  "Are you Sure you want join this Group?"),
                                              actions: <Widget>[
                                                new FlatButton(
                                                    onPressed: () =>
                                                        Navigator.of(
                                                            context)
                                                            .pop(),
                                                    child: new Text(
                                                        "No")),
                                                new FlatButton(
                                                    onPressed: () {
                                                      final DocumentReference postRef = Firestore
                                                          .instance.collection(
                                                          "groups")
                                                          .document(
                                                          document.documentID);
                                                      Firestore.instance
                                                          .runTransaction((
                                                          Transaction tx) async {
                                                        DocumentSnapshot postSnapshot = await tx
                                                            .get(postRef);
                                                        if (postSnapshot.exists) {
                                                          await tx.update(postRef,
                                                              <String, dynamic>{
                                                                'members': FieldValue.arrayUnion([widget.uid]),
                                                              });
                                                        }
                                                      });
                                                      Navigator.of(
                                                          context).pop();
                                                    }, child: new Text(
                                                    "Yes"))
                                              ],
                                            );
                                          }),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height/4,
                                        child: new Card(
                                          elevation: 1.0,
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(18.0),
                                                child: Container(
                                                  height: 85.0,
                                                  width: 85.0,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: CachedNetworkImageProvider(document['image_url']),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0,5,0,0),
                                                child: new Text(document['name'],style: TextStyle(fontWeight: FontWeight.bold),),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList()
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
}