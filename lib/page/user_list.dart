import 'package:dsckiit_app/page/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowUsersList extends StatefulWidget {
  final String uid;
  ShowUsersList({Key key,this.uid}) : super(key:key);
  @override
  _ShowUsersListState createState() => _ShowUsersListState();
}

class _ShowUsersListState extends State<ShowUsersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
        Firestore.instance.collection('users').snapshots(),
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
                scrollDirection: Axis.vertical,
                children: snapshot.data.documents
                    .map((DocumentSnapshot document) {
                  return widget.uid != document.documentID ? GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          ChatPage(
                            to: document.documentID,
                            from: widget.uid,
                            groupId: null,
                            url:'https://firebasestorage.googleapis.com/v0/b/myra-health.appspot.com/o/pf.png?alt=media&token=0a4f0eef-0aac-4b76-9cea-5f0f2bcde42f',
                            groupName: document['name'],
                          )));
                    },
                    child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Padding(padding: EdgeInsets.only(left: 10),),
                              new Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/myra-health.appspot.com/o/pf.png?alt=media&token=0a4f0eef-0aac-4b76-9cea-5f0f2bcde42f',
                                    height: 70,
                                    width: 70,
                                  )
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
                  ) : SizedBox();
                }).toList(),
              );
          }
        },
      ),
    );
  }
}
