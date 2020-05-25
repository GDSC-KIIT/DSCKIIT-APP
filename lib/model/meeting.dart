class Meeting {
  String _title;
  String _time;
  String _link;
  String _date;
 
  Meeting(this._title, this._link, this._date, this._time);
 
  Meeting.map(dynamic obj) {
    this._title = obj['title'];
    this._link = obj['link'];
    this._date = obj['date'];
    this._date = obj['time'];
  }
 
  String get title => _title;
  String get time => _time;
  String get link => _link;
  String get date => _date;
 
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['title'] = _title;
    map['time'] = _time;
    map['link'] = _link;
    map['date'] = _date;
 
    return map;
  }
 
  Meeting.fromMap(Map<String, dynamic> map) {
    this._title = map['title'];
    this._time = map['time'];
    this._link = map['link'];
    this._date = map['date'];
  }
}
