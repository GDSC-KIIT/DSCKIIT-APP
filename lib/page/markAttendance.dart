import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MarkAttendance extends StatefulWidget {
  String uid;
  MarkAttendance({this.uid});
  @override
  _MarkAttendanceState createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {

  List<String> _attendees = new List();

  void populateAttendees() async{
    await Firestore.instance.collection('meetings').document(widget.uid).get().then((DocumentSnapshot documentSnapshot){
      if(documentSnapshot.data['attendees'] != null){
        print(documentSnapshot.data['attendees']);
        documentSnapshot.data['attendees'].forEach((uid){
          _attendees.add(uid);
        });
      }
      setState(() {
        _attendees = LinkedHashSet<String>.from(_attendees).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    populateAttendees();
    print(_attendees);
  }

  bool onChoice(String uid){
    if(_attendees.indexOf(uid) != -1){
        setState(() {
          _attendees.removeAt(_attendees.indexOf(uid));
        });
        return false;
    }else{
      setState(() {
        if(uid != null){
          _attendees.add(uid);
        }
      });
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return CircularProgressIndicator();
          return ListView(
            children: snapshot.data.documents.map<Widget>((DocumentSnapshot documentSnapshot){
              return documentSnapshot.data['uid'] == null ? SizedBox() : AttendeeCard(
                uid: documentSnapshot.data['uid'],
                name: documentSnapshot.data['displayName'],
                onChangeHandler: onChoice,
                value: _attendees.indexOf(documentSnapshot.data['uid']) == -1 ? false : true,
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.save),
          onPressed: () async{
            List<String> _absentees = new List();
            await Firestore.instance.collection('users').getDocuments().then((QuerySnapshot snapshot){
              snapshot.documents.forEach((element) {
                if(_attendees.indexOf(element.data['uid']) == -1){
                  if(element.data['uid'] != null){
                    _absentees.add(element.data['uid']);
                  }
                }
              });
            });
            _absentees = LinkedHashSet<String>.from(_absentees).toList();
            Firestore.instance.collection('meetings').document(widget.uid).updateData({"attendees": _attendees, "absentees" : _absentees});
          },
          label: Text("Save"),
      ),
    );
  }
}

class AttendeeCard extends StatefulWidget {
  AttendeeCard({this.name, this.onChangeHandler, this.uid, this.value});
  bool value;
  String uid;
  Function onChangeHandler;
  String name;
  @override
  _AttendeeCardState createState() => _AttendeeCardState();
}

class _AttendeeCardState extends State<AttendeeCard> {

  @override
  Widget build(BuildContext context) {
    bool value = widget.value;
    return GestureDetector(
      onTap: (){
        widget.onChangeHandler(widget.uid);
      },
      child: Container(
        padding: EdgeInsets.all(20),
        color: value ? Colors.green : Colors.white,
        child: Center(
          child: Text(
            widget.name,
            style: TextStyle(color: value ? Colors.white: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
