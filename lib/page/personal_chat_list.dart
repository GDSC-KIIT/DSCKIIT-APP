import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsckiit_app/page/chat_page.dart';
import 'package:dsckiit_app/page/user_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:collection';

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

  @override
  void initState(){
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add
          ),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ShowUsersList(uid: widget.uid,)))
      ),
      body: (data!=null && data.length!=0) ? new ListView.builder(
          itemCount: data.length,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext ctx,int index){
            return GestureDetector(
              onTap: (){
                Firestore.instance
                    .collection('users')
                    .document(data[index])
                    .get()
                    .then((DocumentSnapshot ds) {
                  setState(() {
                  });
                  return ds['displayName'];
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    ChatPage(
                      to: data[index],
                      from: widget.uid,
                      groupId: null,
                      url:'https://firebasestorage.googleapis.com/v0/b/myra-health.appspot.com/o/pf.png?alt=media&token=0a4f0eef-0aac-4b76-9cea-5f0f2bcde42f',
                      groupName: nameData[index],
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
                                        child: new Text(snapshot.data,style: TextStyle(fontWeight: FontWeight.bold),),
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
          }
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}
