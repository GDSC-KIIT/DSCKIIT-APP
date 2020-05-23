import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetingsPage extends StatefulWidget {
  @override
  _MeetingsPageState createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<MeetingsPage> {

  void _launchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: Center(
        child: MeetingCard(
          title: "Zoom Meeting",
          time: "23/5/2020",
          url: "https://www.google.com",
          onJoin: _launchUrl,
          onTrack: (){},
        ),
      ),
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
    return Container(
      height: 150,
      width: 325,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
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
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MeetingInfo()));
                    },
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
                    onPressed: onJoin(url),
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
    );
  }
}
