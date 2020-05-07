import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsckiit_app/page/chat_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class GroupDetailsPage extends StatefulWidget {
  final String userId,uid;
  const GroupDetailsPage({Key key, this.userId,this.uid}) : super(key: key);
  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

//final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
class _GroupDetailsPageState extends State<GroupDetailsPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    var format = new DateFormat("yMMMd");
    var format1 = new DateFormat("Hm");
    Future<Null> _leaveGroup() async {
      showDialog(context: context,builder: (BuildContext buildContext){
        return AlertDialog(
          title: Text("Are You Sure you want to leave thie group?"),
          actions: <Widget>[
            FlatButton(
              child: Text("No"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: (){
                final DocumentReference postRef = Firestore
                    .instance.collection(
                    "groups")
                    .document(
                    widget.userId);
                Firestore.instance
                    .runTransaction((Transaction tx) async {
                  DocumentSnapshot postSnapshot = await tx.get(postRef);
                  if (postSnapshot.exists) {
                    await tx.update(postRef,
                        <String, dynamic>{
                          'members': FieldValue.arrayRemove([widget.uid]),
                        }).then((result) {
                      var count = 0;
                      Navigator.pop(context);
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.popUntil(context, (route) {
                          return count++ == 2;
                        });
                      });
                    });
                  }
                });
              },
            ),
          ],
        );
      });
    }

    return SafeArea(
      child: Scaffold(
          body: StreamBuilder(
              stream: Firestore.instance.collection('groups').document(
                  '${widget.userId}').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Text("Loading");
                }
                var ds1 = snapshot.data;
                return Scaffold(
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height/2,
                              width: deviceWidth,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: ds1['image_url']
                                      .toString()
                                      .isNotEmpty ? CachedNetworkImageProvider(
                                      ds1['image_url']
                                  ) : Image.asset('assets/mascot.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(12.0),
                            shadowColor: Colors.white,
                            child: Container(
                              padding: EdgeInsets.all(15.0),
                              width: deviceWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.white,
                              ),
                              constraints: BoxConstraints(minHeight: 100.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(
                                          left: 5.0, top: 5.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            ds1['name'],
                                            style: TextStyle(
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                        ],
                                      )),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 5.0, right: 20.0),
                                    child: Text(
                                      "Created: " + format.format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              ds1['created_time'])) + ',' +
                                          format1.format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  ds1['created_time'])),
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 5.0, right: 5.0),
                                    child: Text(
                                      ds1['description'],
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0,right: 15,bottom: 15),
                          child: Text(
                            'Group Members',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        ds1['members']!=null ? ListView.builder(
                          padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: ds1['members'].length,
                            itemBuilder: (ctx,index){
                              String id = ds1['members'][index].toString();
                              String name= "";
                              String photoUrl="";
                              return Padding(
                                padding: EdgeInsets.only(left: 15.0,right: 15),
                                child: GestureDetector(
                                  onTap: widget.uid != id ?  () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(to: id,url: photoUrl,from: widget.uid,groupName: name))) : (){},
                                  child: Container(
                                    color: Colors.white,
                                    child: new Card(
                                      elevation: 0.0,
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                FutureBuilder<DocumentSnapshot>(
                                                    future: Firestore.instance
                                                        .collection('users')
                                                        .document(id)
                                                        .get()
                                                        .then((DocumentSnapshot ds) {
                                                          name = ds['displayName'];
                                                          photoUrl = ds['photoURL'];
                                                      return ds;
                                                    }),
                                                    builder: (context,snapshot){
                                                      if(snapshot.hasData){
                                                        return Row(
                                                          children: <Widget>[
                                                            Container(
                                                              margin: EdgeInsets.only(right: 10.0),
                                                              height: 50.0,
                                                              width: 50.0,
                                                              decoration: BoxDecoration(
                                                              ),
                                                              child: ClipOval(
                                                                child: FadeInImage.assetNetwork(
                                                                    placeholder: "assets/mascot.png",
                                                                    image: snapshot.data['photoURL'].toString().isNotEmpty ? snapshot.data['photoURL'] :
                                                                    'https://firebasestorage.googleapis.com/v0/b/myra-health.appspot.com/o/pf.png?alt=media&token=0a4f0eef-0aac-4b76-9cea-5f0f2bcde42f',
                                                                    fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            ),
                                                            Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: <Widget>[
                                                                Row(
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 10.0),
                                                                      child: new Text(snapshot.data['displayName'],style: TextStyle(fontWeight: FontWeight.bold),),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        );
                                                      }else if(snapshot.hasError){
                                                        return new Center(
                                                          child: Text("${snapshot.error}"),
                                                        );
                                                      }
                                                      return new Container(alignment: AlignmentDirectional.center,child: new SizedBox(height: 0,),);
                                                    }
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 1,
                                            indent: 3.0,
                                            endIndent: 3.0,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                        ) : new SizedBox(height: 0,),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 30, right: 30, bottom: 10.0),
                            height: 60.0,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(7.0),
                              color: Colors.white,
                              elevation: 10.0,
                              shadowColor: Colors.white70,
                              child: MaterialButton(
                                onPressed: () => _leaveGroup(),
                                child: Text(
                                  'Leave Group',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18.0,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
          )),
    );
  }
}