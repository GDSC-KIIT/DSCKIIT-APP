import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dsckiit_app/model/media.dart';
import 'package:dsckiit_app/services/firestore.dart';
import 'package:image_picker/image_picker.dart';

class MediaScreen extends StatefulWidget {
  final Media media;
  MediaScreen(this.media);

  @override
  State<StatefulWidget> createState() => new _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  TextEditingController _titleController;
  String _photoUrl = 'empty';
  //TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _titleController = new TextEditingController(text: widget.media.title);
    //_descriptionController = new TextEditingController(text: widget.media.photoUrl);
  }

  Future pickImage() async {
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 200.0,
      maxWidth: 200.0,
    );
    String fileName = basename(file.path);
    uploadImage(file, fileName);
  }

  void uploadImage(File file, String fileName) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(fileName);
    storageReference.putFile(file).onComplete.then((firebaseFile) async {
      var downloadUrl = await firebaseFile.ref.getDownloadURL();

      setState(() {
        _photoUrl = downloadUrl;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Media')),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            // TextField(
            //   controller: _descriptionController,
            //   decoration: InputDecoration(labelText: 'Description'),
            // ),
            GestureDetector(
                onTap: () {
                  this.pickImage();
                },
                child: Center(
                  child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: _photoUrl == "empty"
                                  ? AssetImage("assets/mascot.png")
                                  : NetworkImage(_photoUrl),
                              fit: BoxFit.cover))),
                )),
            Padding(padding: new EdgeInsets.all(5.0)),
            RaisedButton(
              child: (widget.media.id != null) ? Text('Update') : Text('Add'),
              onPressed: () {
                if (widget.media.id != null) {
                  db
                      .updateMedia(Media(widget.media.id, _titleController.text,
                          _photoUrl))
                      .then((_) {
                    Navigator.pop(context);
                  });
                } else {
                  db
                      .createMedia(
                          _titleController.text, _photoUrl)
                      .then((_) {
                    Navigator.pop(context);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
