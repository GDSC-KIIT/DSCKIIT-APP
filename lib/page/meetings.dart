import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsckiit_app/Widgets/google_button.dart';
import 'package:dsckiit_app/constants.dart';
import 'package:dsckiit_app/model/meeting.dart';
import 'package:dsckiit_app/page/meetingCreate.dart';
import 'package:dsckiit_app/page/meetingInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetingsPage extends StatefulWidget {
  MeetingsPage({this.user});

  final FirebaseUser user;

  @override
  _MeetingsPageState createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<MeetingsPage> {
  final _db = Firestore.instance;
  bool isAdmin = false;

  checkAdmin(FirebaseUser user) async {
    await _db
        .collection('users')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot) {
      setState(() {
        isAdmin = DocumentSnapshot.data['admin'];
        print(isAdmin);
      });
    });
  }

  List<String> meetings = new List();

  void _launchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  void initState() {
    super.initState();
    this.checkAdmin(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text("Meetings"),
          elevation: 0.0,
          centerTitle: true,
        ),
        floatingActionButton: isAdmin
            ? Padding(
                padding: const EdgeInsets.only(bottom: 30, right: 15),
                child: FloatingActionButton(
                  onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => new CreateMeeting(Meeting('', '', '', ''))),),
                  backgroundColor: Colors.white,
                  child: CustomPaint(
                    child: Container(),
                    foregroundPainter: FloatingPainterGButton(),
                  ),
                ),
              )
            : SizedBox(),
        body: StreamBuilder(
          stream: Firestore.instance.collection('meetings').orderBy('date').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: Text("Loading meetings...."));
            return ListView(
              children: snapshot.data.documents
                  .map<Widget>((DocumentSnapshot documentSnapshot) {
                return MeetingCard(
                  title: documentSnapshot.data['title'],
                  time: documentSnapshot.data['time'],
                  date: documentSnapshot.data['date'],
                  url: documentSnapshot.data['link'],
                  onJoin: _launchUrl,
                  onTrack: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MeetingInfo(
                            uid: documentSnapshot.documentID,
                            title: documentSnapshot.data['title'],
                            isAdmin: isAdmin)));
                  },
                );
              }).toList(),
            );
          },
        ));
  }
}

class MeetingCard extends StatelessWidget {
  String title, time, date;
  String url;
  Function onTrack;
  Function onJoin;
  MeetingCard(
      {this.url, this.date, this.title, this.time, this.onJoin, this.onTrack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 15, 8, 8),
      child: Container(
        height: 160,
        width: 250,
        decoration: BoxDecoration(
          border: Border.all(width: 0.2, color: kFabColor),
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 20.0),
                        child: Text(
                          this.title,
                          style: TextStyle(
                              color: kFabColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 27),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '${this.date}, ${this.time}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(
                      "assets/logo.png",
                      width: 100,
                      height: 75,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 10.0, top: 12.0),
                    child: RaisedButton(
                      color: Colors.lightBlueAccent,
                      onPressed: onTrack,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Track",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 25.0, top: 12.0),
                    child: RaisedButton(
                      color: Colors.lightBlueAccent,
                      onPressed: () => onJoin(url),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Join",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
