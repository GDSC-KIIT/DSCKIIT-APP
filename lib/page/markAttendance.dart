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
              return documentSnapshot.data['uid'] == null ? SizedBox() : Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 10, right: 8.0),
                child: AttendeeCard(
                  ds: documentSnapshot,
                  onChangeHandler: onChoice,
                  value: _attendees.indexOf(documentSnapshot.data['uid']) == -1 ? false : true,
                ),
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
  AttendeeCard({this.onChangeHandler, this.ds, this.value});
  bool value;
  Function onChangeHandler;
  DocumentSnapshot ds;

  @override
  _AttendeeCardState createState() => _AttendeeCardState();
}

class _AttendeeCardState extends State<AttendeeCard> {

  @override
  Widget build(BuildContext context) {
    bool value = widget.value;
    return GestureDetector(
      onTap: (){
        widget.onChangeHandler(widget.ds.data['uid']);
      },
      child: Container(
        padding: EdgeInsets.only(left: 50, top: 10, bottom: 10),
        color: value ? Color(0xFFE9F2FF) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipOval(
                child: FadeInImage.assetNetwork(
                  fadeInDuration: Duration(seconds: 1),
                  height: 50,
                  width: 50,
                  placeholder: "assets/mascot.png",
                  image: widget.ds.data['photoURL'].toString().isNotEmpty ? widget.ds.data['photoURL'] :
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
                    child: Text(widget.ds.data['displayName'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 23),),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(widget.ds.data['email'], style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500, fontSize: 10),),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
