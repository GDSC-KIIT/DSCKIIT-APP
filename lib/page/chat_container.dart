import 'package:dsckiit_app/page/groups_list.dart';
import 'package:dsckiit_app/page/personal_chat_list.dart';
import 'package:flutter/material.dart';

class ChatContainer extends StatefulWidget {
  final String uid;

  ChatContainer({Key key, this.uid}) : super(key: key);

  @override
  _ChatContainerState createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            tabs: [
              Tab(
                text: "Group\'s Available",
              ),
              Tab(
                text: "Group\'s Joined",
              ),
              Tab(
                text: "Personal",
              ),
            ],
          ),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Text('Messages',
                  style: AppBarTheme.of(context).textTheme.title),
            ),
          ),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            new GroupsList(
              joined: false,
              uid: widget.uid,
            ),
            new GroupsList(
              joined: true,
              uid: widget.uid,
            ),
            new PersonalChat(uid: widget.uid)
          ],
        ),
      ),
    );
  }
}
