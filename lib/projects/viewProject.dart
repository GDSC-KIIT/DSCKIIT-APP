import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dsckiit_app/projects/editProject.dart';
import 'package:dsckiit_app/model/projects.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewProject extends StatefulWidget {
  final String id;
  ViewProject(this.id);
  @override
  _ViewProjectState createState() => _ViewProjectState(id);
}

class _ViewProjectState extends State<ViewProject> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  String id;
  _ViewProjectState(this.id);

  Project _project;
  bool isLoading = true;

  getProject(id) async {
    _databaseReference.child(id).onValue.listen((event) {
      setState(() {
        _project = Project.fromSnapshot(event.snapshot);
        isLoading = false;
      });
    });
  }

  _launchURL(String repo) async {
    String url = '$repo';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  deleteProject() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Do you want to delete?'),
            content: Text("Delete Contact"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _databaseReference.child(id).remove();
                    navigateToLastScreen();
                  },
                  child: Text('Delete')),
            ],
          );
        });
  }

  navigateToEditScreen(id) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EditProject(id);
    }));
  }

  navigateToLastScreen() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    this.getProject(id);
  }

  @override
  Widget build(BuildContext context) {
    // wrap screen in WillPopScreen widget
    return Scaffold(
      appBar: AppBar(
        title: Text("View Contact"),
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  // header text container
                  Container(
                      height: 200.0,
                      child: Image(
                        //
                        image: _project.photoUrl == "empty"
                            ? AssetImage("assets/mascot.png")
                            : NetworkImage(_project.photoUrl),
                        fit: BoxFit.contain,
                      )),
                  //name
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.perm_identity),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              "${_project.projectName}",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ),
                  // phone
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.phone),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              "${_project.leadName}",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ),
                  // email
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.email),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              "${_project.domain}",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ),
                  // address
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.home),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              "${_project.number}",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ),
                  // 
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            FlatButton(
                                onPressed: () => _launchURL(_project.repo),
                                child: Image.asset("assets/githubLogo.jpg"))
                          ],
                        )),
                  ),
                  // Edit and Delete
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                              iconSize: 30.0,
                              icon: Icon(Icons.edit),
                              color: Colors.red,
                              onPressed: () {
                                navigateToEditScreen(id);
                              },
                            ),
                            IconButton(
                              iconSize: 30.0,
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                deleteProject();
                              },
                            )
                          ],
                        )),
                  )
                ],
              ),
      ),
    );
  }
}
