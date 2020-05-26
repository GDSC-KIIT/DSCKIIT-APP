import 'package:dsckiit_app/page/markAttendance.dart';
import 'package:dsckiit_app/page/meetingNotes.dart';
import 'package:dsckiit_app/page/showAttendance.dart';
import 'package:flutter/material.dart';

class MeetingInfo extends StatefulWidget {
  final String uid, title;
  final bool isAdmin;
  MeetingInfo({Key key, this.uid, this.title, this.isAdmin}) : super(key: key);

  @override
  _MeetingInfoState createState() => _MeetingInfoState();
}

class _MeetingInfoState extends State<MeetingInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isAdmin;

  @override
  void initState() {
    super.initState();

    this.isAdmin = widget.isAdmin;
    print(isAdmin);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: isAdmin ? 3 : 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            tabs: isAdmin ? [
              Tab(
                text: "Attendance",
              ),
              Tab(
                text: "Mark Attendance",
              ),
              Tab(
                text: "Notes",
              ),
            ] : [
              Tab(
                text: "Attendance",
              ),
              Tab(
                text: "Notes",
              ),
            ] ,
          ),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(widget.title,
                  style: AppBarTheme.of(context).textTheme.title),
            ),
          ),
          centerTitle: true,
        ),
        body: TabBarView(
          children: isAdmin ? [
            ShowAttendance(uid: widget.uid,),
            MarkAttendance(uid: widget.uid,),
            MeetingNotePage(uid: widget.uid,),
          ] : [
            ShowAttendance(uid: widget.uid,),
            MeetingNotePage(uid: widget.uid,),
          ],
        ),
      ),
    );
  }
}
