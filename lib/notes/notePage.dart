import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsckiit_app/Widgets/google_button.dart';
import 'package:dsckiit_app/Widgets/rounded_button.dart';
import 'package:dsckiit_app/model/note.dart';
import 'package:dsckiit_app/notes/addNotes.dart';
import 'package:dsckiit_app/notes/displayNote.dart';
import 'package:dsckiit_app/utils/colors.dart';

import 'package:flutter/material.dart';
import 'package:dsckiit_app/services/firebase.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'noteTile.dart';

class NotePage extends StatefulWidget {
  NotePage({this.num = 0});

  int num;

  @override
  _NotePageState createState() => new _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List<Note> items;
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  StreamSubscription<QuerySnapshot> noteSub;

  List<Color> colors = [
    Color(0xFFfd6b58),
    Color(0xFF407BFE),
    Color(0xFF45C7FE),
    Color(0xFF645FB3),
    Color(0xFF7D9EE8),
    Color(0xFFFF3661),
    Color(0xFF088BA2),
    Colors.black87,
  ];

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
        automaticallyImplyLeading: widget.num == 1 ? true : false,
        title: Text(
          'Meeting Notes',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StaggeredGridView.countBuilder(
          primary: false,
          mainAxisSpacing: 6.0,
          crossAxisSpacing: 6.0,
          crossAxisCount: 4,
          itemCount: items.length,
          itemBuilder: (context, index) => GestureDetector(
            onLongPress: (){
              _showCustomMenu(items[index], index);
            },
            onTapDown: _storePosition,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DisplayNote(
                        title: items[index].title,
                        content: items[index].description,
                      )));
            },
            child: MyTile(
              title: items[index].title,
              content: items[index].description,
              color: colors[index % colors.length],
            ),
          ),
          staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        ),
      ),
//      body: ListView.builder(
//          itemCount: items.length,
//          itemBuilder: (context, position) {
//            return Column(
//              children: <Widget>[
//                SizedBox(height: 10),
//                Container(
//                  decoration: BoxDecoration(
//                    color: primaryColor,
//                    borderRadius: BorderRadius.circular(20),
//                  ),
//                  height: 75,
//                  width: MediaQuery.of(context).size.width * 0.95,
//                  child: Center(
//                    child: GestureDetector(
//                      onTap: () => _navigateToNote(context, items[position]),
//                      child: ListTile(
//                        leading: CircleAvatar(
//                          minRadius: 10,
//                          maxRadius: 22,
//                          backgroundImage: AssetImage(
//                            'assets/mascot.png',
//                          ),
//                          backgroundColor: Colors.white,
//                        ),
//                        title: Text(
//                          this.items[position].title,
//                          style: TextStyle(
//                            color: Colors.white,
//                            fontWeight: FontWeight.w500,
//                            fontSize: 22.0,
//                          ),
//                        ),
//                        trailing: GestureDetector(
//                          child: Icon(
//                            Icons.remove_circle,
//                            color: Colors.white,
//                          ),
//                          onTap: () =>
//                              _deleteNote(context, items[position], position),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            );
//          }),
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
        items.removeAt(position);

        noteSub = db.getNoteList().listen((QuerySnapshot snapshot) {
          final List<Note> notes = snapshot.documents
              .map((documentSnapshot) => Note.fromMap(documentSnapshot.data))
              .toList();

          setState(() {
            this.items = notes;
          });
        });
    });
  }

  void _navigateToUpdateNote(BuildContext context, Note note) async {
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

  var _tapPosition;

  void _showCustomMenu(Note note, int index) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    int delta = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        _tapPosition & Size(40,40),
        Offset.zero & overlay.semanticBounds.size,
      ),
      items: <PopupMenuEntry<int>>[
        PopupMenuItem(child: Icon(Icons.edit), value: 1),
        PopupMenuItem(child: Icon(Icons.delete), value: 2),
      ],
    );
    if(delta == null){
      return;
    }
    navigateToPage(context, note, delta, index);
  }

  void navigateToPage(BuildContext context, Note note, int value, int index){
    if(value == 1){
      _navigateToUpdateNote(context, note);
    }else{
      print(index);
      _deleteNote(context, note, index);
    }
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

}
