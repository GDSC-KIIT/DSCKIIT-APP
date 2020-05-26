import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsckiit_app/Widgets/google_button.dart';
import 'package:dsckiit_app/model/note.dart';
import 'package:dsckiit_app/notes/addNotes.dart';
import 'package:dsckiit_app/notes/displayNote.dart';
import 'package:dsckiit_app/notes/noteTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MeetingNotePage extends StatefulWidget {
  MeetingNotePage({this.uid});

  String uid;

  @override
  _MeetingNotePageState createState() => new _MeetingNotePageState();
}

class _MeetingNotePageState extends State<MeetingNotePage> {
  List<Note> items;
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

  Stream<QuerySnapshot> getNoteList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = Firestore.instance.collection("meetings").document(widget.uid).collection("notes").getDocuments().asStream();
    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }

  void populateNotes() async {
//    QuerySnapshot docs = await Firestore.instance.collection("meetings").document(widget.uid).collection("notes").getDocuments();
//    var documents = docs.documents;
//    final List<Note> notes = new List();
//    documents.forEach((element) {
//      notes.add(Note.fromMap(element.data));
//      print(element.data);
//    });
//    setState(() {
//      this.items = notes;
//    });
    noteSub = getNoteList().listen((QuerySnapshot snapshot) {
      final List<Note> notes = snapshot.documents
          .map((documentSnapshot) => Note.fromMap(documentSnapshot.data))
          .toList();

      setState(() {
        this.items = notes;
        print(items);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    items = new List();
    noteSub?.cancel();
    populateNotes();
  }

  @override
  void dispose() {
    noteSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await Firestore.instance.collection("meetings").document(widget.uid).collection("notes").document(note.id).get();
      await tx.delete(ds.reference);
      return {'deleted' : true};
    };
    Firestore.instance.runTransaction(deleteTransaction).then((result){
      print(result);
    }).catchError((error){
      print("Error : $error");
    });
    setState(() {
      items.removeAt(position);
    });
  }

  void _navigateToUpdateNote(BuildContext context, Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(note, widget.uid)),
    ).then((value){
      populateNotes();
    });
  }

  void _createNewNote(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(Note(null, '', ''), widget.uid)),
    ).then((value){
      populateNotes();
    });
  }

  var _tapPosition;

  void _showCustomMenu(Note note, int index) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    int delta = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        _tapPosition & Size(20,20),
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
