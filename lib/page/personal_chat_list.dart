import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsckiit_app/constants.dart';
import 'package:dsckiit_app/page/chat_page.dart';
import 'package:dsckiit_app/page/user_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:dsckiit_app/Widgets/google_button.dart';

class PersonalChat extends StatefulWidget {
  final String uid;
  PersonalChat({Key key, this.uid}) : super(key: key);

  @override
  _PersonalChatState createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {

  List<String> data = new List<String>();
  List<String> data1 = new List<String>();
  List<String> nameData = new List<String>();
  List<String> photoData = new List<String>();

  @override
  void initState(){
    super.initState();
    FirebaseDatabase.instance.reference().child('messages/personalMessage').once().then((dataSnapshot){
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((key,values) {
        if (values['from'] == widget.uid) {
          setState(() {
            data1.add(values['to']);
          });
        }else if (values['to'] == widget.uid){
          setState(() {
            data1.add(values['from']);
          });
        }
      });
      setState(() {
        data = LinkedHashSet<String>.from(data1).toList();
      });
    });
  }

  Future<Null> refresh() async{

    await FirebaseDatabase.instance.reference().child('messages/personalMessage').once().then((dataSnapshot){
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((key,values) {
        if (values['from'] == widget.uid) {
          setState(() {
            data1.add(values['to']);
          });
        }else if (values['to'] == widget.uid){
          setState(() {
            data1.add(values['from']);
          });
        }
      });
      setState(() {
        data = LinkedHashSet<String>.from(data1).toList();
      });
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
          child: CustomPaint(
              child: Container(),
              foregroundPainter: FloatingPainterGButton(),
            ),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ShowUsersList(uid: widget.uid,)))
      ),
      body: (data!=null && data.length!=0) ? RefreshIndicator(
        onRefresh: refresh,
        child: new ListView.builder(
            itemCount: data.length,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext ctx,int index){
              return GestureDetector(
                onTap: (){
                  String name;
                  String url;
                  Firestore.instance
                      .collection('users')
                      .document(data[index])
                      .get()
                      .then((DocumentSnapshot ds) {
                    setState(() {
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        ChatPage(
                          to: data[index],
                          from: widget.uid,
                          groupId: null,
                          url: ds['photoURL'],
                          groupName: ds['displayName'],
                        )));
//                  name = ds['displayName'];
//                  url = ds['photoURL'];
//                  print(name);
//                  print(url);
//                  print(ds['displayName']);
//                  print(data[index]);
//                  print(nameData[index]);
                  });

                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black12),BoxShadow(color: Colors.black12),BoxShadow(color: Colors.black12),BoxShadow(color: Colors.black12)],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  margin: EdgeInsets.only(left: 7, right: 7, top: 10),
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
                          FutureBuilder<DocumentSnapshot>(
                              future: Firestore.instance
                                  .collection('users')
                                  .document(data[index])
                                  .get()
                                  .then((DocumentSnapshot ds) {
                                    setState(() {
                                      photoData.add(ds['photoURL']);
                                    });
                                return ds;
                              }),
                              builder: (context,snapshot){
                                if(snapshot.hasData){
                                  return Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(right: 20.0),
                                        height: 60.0,
                                        width: 60.0,
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
                                    ],
                                  );
                                }else if(snapshot.hasError){
                                  return new Center(
                                    child: SizedBox(),
                                  );
                                }
                                return new Container(alignment: AlignmentDirectional.center,child: new SizedBox(height: 0,),);
                              }
                          ),
//                        new Padding(
//                            padding: const EdgeInsets.all(10.0),
//                            child: Image.network(
//                              'https://firebasestorage.googleapis.com/v0/b/myra-health.appspot.com/o/pf.png?alt=media&token=0a4f0eef-0aac-4b76-9cea-5f0f2bcde42f',
//                              height: 70,
//                              width: 70,
//                            )
//                        ),
                          FutureBuilder<String>(
                              future: Firestore.instance
                                  .collection('users')
                                  .document(data[index])
                                  .get()
                                  .then((DocumentSnapshot ds) {
                                setState(() {
                                  nameData.add(ds['displayName']);
                                });
                                return ds['displayName'];
                              }),
                              builder: (context,snapshot){
                                if(snapshot.hasData){
                                  return
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10.0,bottom: 5),
                                          child: new Text(snapshot.data,style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                                        ),
                                      ],
                                    );
                                }else if(snapshot.hasError){
                                  return new Center(
                                    child:
                                    new Text("${snapshot.error}"),
                                  );
                                }
                                return new Container(alignment: AlignmentDirectional.center,child: new SizedBox(),);
                              }
                          )
                        ],
                      ),
//                    Divider(
//                      height: 1.5,
//                      indent: 8.0,
//                      endIndent: 8.0,
//                      color: Color(0xffE2E2E2),
//                    )
                    ],
                  ),
                ),
              );
            }
        ),
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}
