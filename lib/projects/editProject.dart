import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dsckiit_app/model/projects.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditProject extends StatefulWidget {
  final String id;
  EditProject(this.id);

  @override
  _EditProjectState createState() => _EditProjectState(id);
}

class _EditProjectState extends State<EditProject> {
  String id;
  _EditProjectState(this.id);

  String _projectName = '';
  String _leadName = '';
  String _domain = '';
  String _number = '';
  String _repo = '';
  String _photoUrl;

  //TextEdttingController
  TextEditingController _pnController = TextEditingController();
  TextEditingController _lnController = TextEditingController();
  TextEditingController _doController = TextEditingController();
  TextEditingController _nuController = TextEditingController();
  TextEditingController _reController = TextEditingController();
  bool isLoading = true;

  //Helper
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    this.getContact(id);
  }

  getContact(id) async {
    Project project;

    _databaseReference.child(id).onValue.listen((event) {
      project = Project.fromSnapshot(event.snapshot);

      _pnController.text = project.projectName;
      _lnController.text = project.leadName;
      _doController.text = project.domain;
      _nuController.text = project.number;
      _reController.text = project.repo;

      setState(() {
        _projectName = project.projectName;
        _leadName = project.leadName;
        _domain = project.domain;
        _number = project.number;
        _repo = project.repo;
        _photoUrl = project.photoUrl;

        isLoading = false;
      });
    });
  }

  //Update Contact
  updateContact(BuildContext context) async {
    if (_projectName.isNotEmpty &&
        _leadName.isNotEmpty &&
        _domain.isNotEmpty &&
        _number.isNotEmpty &&
        _repo.isNotEmpty) {
      Project project = Project.withId(
          this.id,
          this._projectName,
          this._leadName,
          this._domain,
          this._number,
          this._repo,
          this._photoUrl);

      await _databaseReference.child(id).set(project.toJson());
      navigateTolLastScreen(context);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Empty Fields"),
              content: Text("Please fill all the fields"),
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

  //Pick Image
  Future pickImage() async {
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 200.0,
      maxWidth: 200.0,
    );
    String fileName = basename(file.path);
    uploadImage(file, fileName);
  }

  //Upload Image
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

  navigateTolLastScreen(BuildContext context) {
    Navigator.pop(context);
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Contact"),
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    //image view
                    Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            this.pickImage();
                          },
                          child: Center(
                            child: Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: _photoUrl == "empty"
                                          ? AssetImage("assets/mascot.png")
                                          : NetworkImage(_photoUrl),
                                    ))),
                          ),
                        )),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _projectName = value;
                          });
                        },
                        controller: _pnController,
                        decoration: InputDecoration(
                          labelText: 'Project Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _leadName = value;
                          });
                        },
                        controller: _lnController,
                        decoration: InputDecoration(
                          labelText: 'Project Lead',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _domain = value;
                          });
                        },
                        controller: _doController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Domain',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _number = value;
                          });
                        },
                        controller: _nuController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _repo = value;
                          });
                        },
                        controller: _reController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    // update button
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                        onPressed: () {
                          updateContact(context);
                        },
                        color: Colors.red,
                        child: Text(
                          "UPDATE",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
