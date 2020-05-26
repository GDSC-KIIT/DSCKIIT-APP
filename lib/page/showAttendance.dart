import 'dart:collection';
import 'package:async_loader/async_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShowAttendance extends StatefulWidget {
  String uid;

  ShowAttendance({this.uid});

  @override
  _ShowAttendanceState createState() => _ShowAttendanceState();
}

class _ShowAttendanceState extends State<ShowAttendance> {
  final GlobalKey<AsyncLoaderState> asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  List<String> _attendees = new List();
  List<String> _absentees = new List();

  Future<List<List<String>>> populateLists() async {
    _absentees = new List();
    _attendees = new List();
//    var dt = await Firestore.instance.collection('users').getDocuments();
//    var _documents = dt.documents;
    await Firestore.instance
        .collection('meetings')
        .document(widget.uid)
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.data['attendees'] != null) {
        ds.data['attendees'].forEach((uid) {
          _attendees.add(uid);
//          _documents.forEach((element) {
//            if (element.documentID == uid)
//              _attendees.add(element.data['displayName']);
//          });
        });
      }
      if (ds.data['absentees'] != null) {
        ds.data['absentees'].forEach((uid) {
          _absentees.add(uid);
//          _documents.forEach((element) {
//            if (element.documentID == uid)
//              _absentees.add(element.data['displayName']);
//          });
        });
      }
    });
//    setState(() {
//      _attendees = LinkedHashSet<String>.from(_attendees).toList();
//      _absentees = LinkedHashSet<String>.from(_absentees).toList();
//    });
    print(_absentees);
    print(_attendees);
    return Future.value([_attendees, _absentees]);
  }

  Future<Null> _handleRefresh() async {
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  Widget getBody(data) {
    return Body(data);
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: asyncLoaderState,
      initState: () async => await populateLists(),
      renderLoad: () => Center(
        child: Image.asset('assets/animator.gif'),
      ),
      renderSuccess: ({data}) => getBody(data),
      renderError: ([error]) => Center(child: Text("$error")),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Center(child: _asyncLoader),
      ),
    );
  }
}

class Body extends StatefulWidget {
  List<List<String>> data;

  Body(this.data);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool showAbsent = true;

  @override
  Widget build(BuildContext context) {
    List<List<String>> data = widget.data;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showAbsent = true;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      color: showAbsent ? Color(0xFFE9F2FF) : Colors.white,
                      border: Border.all(
                        color: showAbsent ? Color(0xFFE9F2FF) : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "Absent",
                        style: TextStyle(
                            color: showAbsent ? Color(0xFF3497FD) : Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showAbsent = false;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      color: !showAbsent ? Color(0xFFE9F2FF) : Colors.white,
                      border: Border.all(
                        color: !showAbsent ? Color(0xFFE9F2FF) : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "Present",
                        style: TextStyle(
                            color: !showAbsent ? Color(0xFF3497FD) : Colors.grey),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: showAbsent ? data[1].length : data[0].length,
              itemBuilder: (context, index){
                return Container(
                  margin: EdgeInsets.only(left: 20, bottom: 10),
                  child: FutureBuilder<DocumentSnapshot>(
                    future: Firestore.instance.collection('users').document(showAbsent ? data[1][index] : data[0][index]).get().then((DocumentSnapshot ds){
                      return ds;
                    }),
                    builder:(context, snapshot){
                      if(snapshot.hasData){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ClipOval(
                                child: FadeInImage.assetNetwork(
                                  height: 50,
                                  width: 50,
                                  placeholder: "assets/mascot.png",
                                  image: snapshot.data['photoURL'].toString().isNotEmpty ? snapshot.data['photoURL'] :
                                  'https://firebasestorage.googleapis.com/v0/b/myra-health.appspot.com/o/pf.png?alt=media&token=0a4f0eef-0aac-4b76-9cea-5f0f2bcde42f',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(snapshot.data['displayName'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 23),),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(snapshot.data['email'], style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500, fontSize: 10),),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError){
                        return Center(child: Text("Some error has occured"));
                      }
                      if(index == 0){
                        return new Container(alignment: AlignmentDirectional.center,child: Text("Loading.."),);
                      }else{
                        return new Container(alignment: AlignmentDirectional.center,child: SizedBox(),);
                      }

                    }
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
