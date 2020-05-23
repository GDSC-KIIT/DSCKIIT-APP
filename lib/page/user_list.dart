import 'package:dsckiit_app/page/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowUsersList extends StatefulWidget {
  final String uid;

  ShowUsersList({Key key, this.uid}) : super(key: key);

  @override
  _ShowUsersListState createState() => _ShowUsersListState();
}

class _ShowUsersListState extends State<ShowUsersList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Users'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('users').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return widget.uid != document.documentID
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                            to: document.documentID,
                                            from: widget.uid,
                                            groupId: null,
                                            url: document['photoURL']
                                                    .toString()
                                                    .isNotEmpty
                                                ? document['photoURL']
                                                : 'https://firebasestorage.googleapis.com/v0/b/myra-health.appspot.com/o/pf.png?alt=media&token=0a4f0eef-0aac-4b76-9cea-5f0f2bcde42f',
                                            groupName: document['displayName'],
                                          )));
                            },
                            child: document.documentID == "Pvl0FwdJ5mQ8fLrNdU4gRyDXOd72" ? Container() : Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: EdgeInsets.only(left: 7, right: 7),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
//                            new Padding(padding: EdgeInsets.only(left: 10),),
                                      Container(
                                        margin: EdgeInsets.only(right: 20.0),
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: BoxDecoration(),
                                        child: ClipOval(
                                          child: FadeInImage.assetNetwork(
                                            placeholder: "assets/mascot.png",
                                            image: document['photoURL']
                                                    .toString()
                                                    .isNotEmpty
                                                ? document['photoURL']
                                                : 'https://firebasestorage.googleapis.com/v0/b/myra-health.appspot.com/o/pf.png?alt=media&token=0a4f0eef-0aac-4b76-9cea-5f0f2bcde42f',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0, bottom: 5),
                                            child: new Text(
                                              document['displayName'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox();
                  }).toList(),
                );
            }
          },
        ),
      ),
    );
  }
}
