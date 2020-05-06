import 'package:firebase_database/firebase_database.dart';

class Project {
  String _id;
  String _projectName;
  String _leadName;
  String _domain;
  String _number;
  String _url;
  String _photoUrl;

  Project(this._projectName, this._leadName, this._domain, this._number,
      this._url, this._photoUrl);
  Project.withId(this._id, this._projectName, this._leadName, this._domain,
      this._number, this._url, this._photoUrl);

  //Adding getters
  String get id => this._id;
  String get projectName => this._projectName;
  String get leadName => this._leadName;
  String get domain => this._domain;
  String get number => this._number;
  String get url => this._url;
  String get photoUrl => this._photoUrl;

  set firstName(String projectName) {
    this._projectName = projectName;
  }

  set lastName(String leadName) {
    this._leadName = leadName;
  }

  set phone(String domain) {
    this._domain = domain;
  }

  set address(String number) {
    this._number = number;
  }

  set email(String url) {
    this._url = url;
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
    this._url = snapshot.value['url'];
    this._photoUrl = snapshot.value['photoUrl'];
  }

  Map<String, dynamic> toJson() {
    return {
      "projectName": _projectName,
      "leadName": _leadName,
      "domain": _domain,
      "number": _number,
      "url": _url,
      "photoUrl": _photoUrl,
    };
  }
}
