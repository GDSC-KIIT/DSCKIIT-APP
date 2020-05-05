import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dsckiit_app/model/projects.dart';
import 'package:path/path.dart';

class AddProject extends StatefulWidget {
  @override
  _AddProjectState createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  String _projectName = '';
  String _leadName = '';
  String _domain = '';
  String _number = '';
  String _url = '';
  String _photoUrl = "empty";

  saveContact(BuildContext context) async {
    if (_projectName.isNotEmpty &&
        _leadName.isNotEmpty &&
        _domain.isNotEmpty &&
        _number.isNotEmpty &&
        _url.isNotEmpty) {
      Project project = Project(this._projectName, this._leadName, this._domain,
          this._number, this._url, this._photoUrl);

      await _databaseReference.push().set(project.toJson());
      navigateToLastScreen(context);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Fields are Empty"),
              content: Text("Please fill all the Fields"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  navigateToLastScreen(context) {
    Navigator.of(context).pop();
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
      appBar: AppBar(
        title: Text('Add ')
      ),
    );
  }
}
