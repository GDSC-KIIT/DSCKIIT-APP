import 'dart:collection';
import 'package:async_loader/async_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    var dt = await Firestore.instance.collection('users').getDocuments();
    var _documents = dt.documents;
    await Firestore.instance
        .collection('meetings')
        .document(widget.uid)
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.data['attendees'] != null) {
        ds.data['attendees'].forEach((uid) {
          _documents.forEach((element) {
            if (element.documentID == uid)
              _attendees.add(element.data['displayName']);
          });
        });
      }
      if (ds.data['absentees'] != null) {
        ds.data['absentees'].forEach((uid) {
          _documents.forEach((element) {
            if (element.documentID == uid)
              _absentees.add(element.data['displayName']);
          });
        });
      }
    });
//    setState(() {
//      _attendees = LinkedHashSet<String>.from(_attendees).toList();
//      _absentees = LinkedHashSet<String>.from(_absentees).toList();
//    });
    return Future.value([_attendees, _absentees]);
  }

  Widget customCard(String title) {
    return Container(
      padding: EdgeInsets.all(10),
      width: 100,
      height: 70,
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget getBody(data) {
    List<Widget> toDisplay = new List();
    toDisplay.add(SizedBox(height: 10));
    toDisplay.add(
      Text(
        "Absent:",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
    toDisplay.add(SizedBox(height: 10));
    data[1].forEach((value) {
      toDisplay.add(customCard(value));
    });
    toDisplay.add(
      Text(
        "Present:",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
    toDisplay.add(SizedBox(height: 10));
    data[0].forEach((value) {
      toDisplay.add(customCard(value));
    });

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: ListView(
        physics: ScrollPhysics(),
        children: toDisplay,
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    asyncLoaderState.currentState.reloadState();
    return null;
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
