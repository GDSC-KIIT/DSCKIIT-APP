class Media {
  String _id;
  String _title;
  String _photoUrl = 'empty';

  Media(this._id, this._title, this._photoUrl);

  Media.map(dynamic obj) {
    this._id = obj['id'];
    this._title = obj['title'];
    this._photoUrl = obj['photoUrl'];
  }

  String get id => _id;
  String get title => _title;
  String get photoUrl => _photoUrl;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['photoUrl'] = _photoUrl;

    return map;
  }

  Media.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._photoUrl = map['photoUrl'];
  }
}
