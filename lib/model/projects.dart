import 'package:firebase_database/firebase_database.dart';

class Project {
  String _id;
  String _projectName;
  String _leadName;
  String _domain;
  String _number;
  String _repo;
  String _photoUrl;

  Project(this._projectName, this._leadName, this._domain, this._number,
      this._repo, this._photoUrl);
  Project.withId(this._id, this._projectName, this._leadName, this._domain,
      this._number, this._repo, this._photoUrl);

  //Adding getters
  String get id => this._id;
  String get projectName => this._projectName;
  String get leadName => this._leadName;
  String get domain => this._domain;
  String get number => this._number;
  String get repo => this._repo;
  String get photoUrl => this._photoUrl;


  //Adding Setters
  set projectName(String projectName) {
    this._projectName = projectName;
  }

  set leadName(String leadName) {
    this._leadName = leadName;
  }

  set domain(String domain) {
    this._domain = domain;
  }

  set number(String number) {
    this._number = number;
  }

  set repo(String repo) {
    this._repo = repo;
  }

  set photoUrl(String photoUrl) {
    this._photoUrl = photoUrl;
  }

  Project.fromSnapshot(DataSnapshot snapshot) {
    this._id = snapshot.key;
    this._projectName = snapshot.value['projectName'];
    this._leadName = snapshot.value['leadName'];
    this._domain = snapshot.value['domain'];
    this._number = snapshot.value['number'];
    this._repo = snapshot.value['repo'];
    this._photoUrl = snapshot.value['photoUrl'];
  }

  Map<String, dynamic> toJson() {
    return {
      "projectName": _projectName,
      "leadName": _leadName,
      "domain": _domain,
      "number": _number,
      "repo": _repo,
      "photoUrl": _photoUrl,
    };
  }
}
