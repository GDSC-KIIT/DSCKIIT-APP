import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dsckiit_app/model/note.dart';
import 'package:dsckiit_app/services/firebase.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  String meetingUid;
  NoteScreen(this.note, this.meetingUid);

  @override
  State<StatefulWidget> createState() => new _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  TextEditingController _titleController;
  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _titleController = new TextEditingController(text: widget.note.title);
    _descriptionController =
        new TextEditingController(text: widget.note.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child : Center(
          child: Container(
            margin: EdgeInsets.all(15.0),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(padding: new EdgeInsets.all(5.0)),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    minLines: 1,
                    maxLines: 100,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(padding: new EdgeInsets.all(5.0)),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                    onPressed: () {
                      if (widget.note.id != null) {
                        if(widget.meetingUid == null)
                        {
                          // When this page is called from notes page
                          db.updateNote(Note(
                                widget.note.id,
                                _titleController.text.trim(),
                                _descriptionController.text.trim()))
                            .then((_) {
                          Navigator.pop(context);
                          });
                        } else {
                          // When this page is called from meeting notes page
                          Firestore.instance.collection("meetings").document(widget.meetingUid).collection("notes").document(widget.note.id).updateData(
                            Note(widget.note.id, _titleController.text.trim(), _descriptionController.text.trim()).toMap()
                          ).then((value){
                            db.updateNote(Note(
                                widget.note.id,
                                _titleController.text.trim(),
                                _descriptionController.text.trim()))
                                .then((retValue) {
                                  if(!retValue){
                                    print("General meeting of such id ${widget.note.id} doesnt exist");
                                  }
                              Navigator.pop(context);
                            });
                          });
                        }
                      } else {
                        // Creating a new note
                        db.createNote(_titleController.text.trim(),
                                _descriptionController.text.trim())
                            .then((Note n) {
                              // The next two lines are executed when this page is called from meeting notes page as meetingUid != null then
                          if(widget.meetingUid != null){
                            print(n.id);
                            Firestore.instance.collection("meetings").document(widget.meetingUid).collection("notes").document(n.id).setData(n.toMap());
                            }
                          Navigator.pop(context);
                        });
                      }
                    },
                    color: Color(0xFF183E8D),
                    child: (widget.note.id != null)
                        ? Text('Update',
                            style: TextStyle(fontSize: 20.0, color: Colors.white))
                        : Text('Add',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
