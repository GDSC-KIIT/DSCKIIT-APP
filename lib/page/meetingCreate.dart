import 'package:flutter/material.dart';
import 'package:dsckiit_app/model/meeting.dart';
import 'package:dsckiit_app/services/firebase_meeting.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class CreateMeeting extends StatefulWidget {
  final Meeting meeting;
  CreateMeeting(this.meeting);

  @override
  _CreateMeetingState createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  final dateFormat = DateFormat("yyyy-MM-dd");
  final timeFormat = DateFormat("hh:mm a");

  TextEditingController _titleController;
  TextEditingController _timeController;
  TextEditingController _linkController;
  TextEditingController _dateController;

  // saveMeeting(BuildContext context) {
  //   String title = _titleController.text.trim();
  //   String date = _dateController.text.trim();
  //   String time = _timeController.text.trim();
  //   String link = _linkController.text.trim();

  //   Firestore.instance.collection('meetings').add({
  //     "title": title,
  //     "time": time,
  //     "date": date,
  //     "link": link
  //   }).then((value) {
  //     // Navigator.pop(context);
  //     print("done");
  //   });
  // }

  @override
  void initState() {
    super.initState();

    _titleController = new TextEditingController(text: widget.meeting.title);
    _timeController = new TextEditingController(text: widget.meeting.time);
    _linkController = new TextEditingController(text: widget.meeting.link);
    _dateController = new TextEditingController(text: widget.meeting.date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Meeting'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
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
                  child: DateTimeField(
                    controller: _dateController,
                    decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    format: dateFormat,
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    },
                  ),
                ),
                Padding(padding: new EdgeInsets.all(5.0)),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: DateTimeField(
                    controller: _timeController,
                    decoration: InputDecoration(
                        labelText: 'Time',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    format: timeFormat,
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.convert(time);
                    },
                  ),
                ),
                Padding(padding: new EdgeInsets.all(5.0)),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    minLines: 1,
                    maxLines: 100,
                    controller: _linkController,
                    decoration: InputDecoration(
                        labelText: 'Link',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(padding: new EdgeInsets.all(5.0)),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                    // onPressed: saveMeeting(context),
                    onPressed: () {
                      db
                          .createMeeting(
                              _titleController.text.trim(),
                              _dateController.text.trim(),
                              _timeController.text.trim(),
                              _linkController.text.trim())
                          .then((_) {
                        Navigator.pop(context);
                      });
                    },
                    color: Color(0xFF183E8D),
                    child: Text('CREATE',
                        style: TextStyle(fontSize: 20.0, color: Colors.white)),
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
