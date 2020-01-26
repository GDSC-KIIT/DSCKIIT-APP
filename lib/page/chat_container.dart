import 'package:dsckiit_app/page/personal_chat_list.dart';
import 'package:dsckiit_app/screen/chatScreen.dart';
import 'package:flutter/material.dart';

class ChatContainer extends StatefulWidget {
  final String uid;
  ChatContainer({Key key,this.uid}) : super(key:key);
  @override
  _ChatContainerState createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: "Group\'s",),
              Tab(text: "Personal",),
            ],
          ),
          title: Text('Chat'),
        ),
        backgroundColor: Color(0xfffff2f2f2),
        body: TabBarView(
          children: [
            new SizedBox(),
            new PersonalChat(uid: widget.uid,),
          ],
        ),
      ),
    );
  }
}