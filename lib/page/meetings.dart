import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsckiit_app/page/meetingInfo.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetingsPage extends StatefulWidget {
  @override
  _MeetingsPageState createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<MeetingsPage> {

  List<String> meetings = new List();


  void _launchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  void initState() {
    super.initState();

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
      body: StreamBuilder(
        stream: Firestore.instance.collection('meetings').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            return Center(child: Text("Loading meetings...."));
          return ListView(
            children: snapshot.data.documents.map<Widget>((DocumentSnapshot documentSnapshot){
              return MeetingCard(
                title: documentSnapshot.data['title'],
                time: documentSnapshot.data['time'],
                url: documentSnapshot.data['link'],
                onJoin: _launchUrl,
                onTrack: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MeetingInfo(uid: documentSnapshot.documentID, title: documentSnapshot.data['title'])));
                },
              );
            }).toList(),
          );
          },
      )
    );
  }
}

class MeetingCard extends StatelessWidget {
  String title, time;
  String url;
  Function onTrack;
  Function onJoin;
  MeetingCard({this.url, this.title, this.time, this.onJoin, this.onTrack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 150,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 3,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(this.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                      ),
                      SizedBox(height: 3,),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(this.time, style: TextStyle(fontSize: 18),),
                      ),
                    ],
                  ),
                  Image.asset(
                    "assets/logo.png",
                    width: 70,
                    height: 70,
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Colors.lightBlueAccent,
                      onPressed: onTrack,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Track", style: TextStyle(color: Colors.white, fontSize: 18),),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Colors.lightBlueAccent,
                      onPressed: () => onJoin(url),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Join", style: TextStyle(color: Colors.white, fontSize: 18),),
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
