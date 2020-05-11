import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsckiit_app/media/mediaScreen.dart';
import 'package:dsckiit_app/model/media.dart';
import 'package:dsckiit_app/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:dsckiit_app/Widgets/google_button.dart';

class MediaPage extends StatefulWidget {
  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  List<Media> items;
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  StreamSubscription<QuerySnapshot> mediaSub;

  @override
  void initState() {
    super.initState();

    items = new List();

    mediaSub?.cancel();
    mediaSub = db.getMediaList().listen((QuerySnapshot snapshot) {
      final List<Media> media = snapshot.documents
          .map((documentSnapshot) => Media.fromMap(documentSnapshot.data))
          .toList();

      setState(() {
        this.items = media;
      });
    });
  }

  @override
  void dispose() {
    mediaSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppBarTheme.of(context).color,
          iconTheme: AppBarTheme.of(context).iconTheme,
          title: Text(
            "Noticeboard",
            style: AppBarTheme.of(context).textTheme.title,
          ),
          centerTitle: true,
        ),
        body: Center(
            child: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('media').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    return new ListView(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return GestureDetector(
                          //onTap: ()=> _navigateToMedia(context, items[position]),
                          //onLongPress: () => _deleteMedia(context, items[position]),
                          child: new Card(
                            child: Column(children: <Widget>[
                              Image.network(document['photoUrl']),
                              Text('${document['title']}')
                            ]),
                          ),
                        );
                      }).toList(),
                    );
                }
              }),
        )),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            child: CustomPaint(
              child: Container(),
              foregroundPainter: FloatingPainterGButton(),
            ),
            onPressed: () => _createNewMedia(context)));
  }

  void _deleteMedia(BuildContext context, Media media, int position) async {
    db.deleteMedia(media.id).then((notes) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToMedia(BuildContext context, Media media) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MediaScreen(media)),
    );
  }

  void _createNewMedia(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MediaScreen(Media(null, '', ''))),
    );
  }
}
