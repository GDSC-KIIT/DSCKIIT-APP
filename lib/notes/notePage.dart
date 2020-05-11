import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsckiit_app/Widgets/google_button.dart';
import 'package:dsckiit_app/Widgets/rounded_button.dart';
import 'package:dsckiit_app/model/note.dart';
import 'package:dsckiit_app/notes/addNotes.dart';
import 'package:dsckiit_app/utils/colors.dart';

import 'package:flutter/material.dart';
import 'package:dsckiit_app/services/firebase.dart';

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => new _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List<Note> items;
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  StreamSubscription<QuerySnapshot> noteSub;

  @override
  void initState() {
    super.initState();

    items = new List();

    noteSub?.cancel();
    noteSub = db.getNoteList().listen((QuerySnapshot snapshot) {
      final List<Note> notes = snapshot.documents
          .map((documentSnapshot) => Note.fromMap(documentSnapshot.data))
          .toList();

      setState(() {
        this.items = notes;
      });
    });
  }

  @override
  void dispose() {
    noteSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Meeting Notes',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 75,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => _navigateToNote(context, items[position]),
                      child: ListTile(
                        leading: CircleAvatar(
                          minRadius: 10,
                          maxRadius: 22,
                          backgroundImage: AssetImage(
                            'assets/mascot.png',
                          ),
                          backgroundColor: Colors.white,
                        ),
                        title: Text(
                          this.items[position].title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 22.0,
                          ),
                        ),
                        trailing: GestureDetector(
                          child: Icon(
                            Icons.remove_circle,
                            color: Colors.white,
                          ),
                          onTap: () =>
                              _deleteNote(context, items[position], position),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: CustomPaint(
            child: Container(),
            foregroundPainter: FloatingPainterGButton(),
          ),
          onPressed: () => _createNewNote(context)),
    );
  }

  void _deleteNote(BuildContext context, Note note, int position) async {
    db.deleteNote(note.id).then((notes) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToNote(BuildContext context, Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(note)),
    );
  }

  void _createNewNote(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(Note(null, '', ''))),
    );
  }
}
