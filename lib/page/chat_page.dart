import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dsckiit_app/page/chat_bubble.dart';
import 'package:dsckiit_app/page/group_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final auth = FirebaseAuth.instance;
var currentUserEmail;

class ChatPage extends StatefulWidget {
  @override
  ChatScreenState createState() => new ChatScreenState();
  final String to, from, groupName, groupId, url, uid, name;

  ChatPage(
      {Key key,
      this.to,
      this.from,
      this.groupId,
      this.url,
      this.groupName,
      this.uid,
      this.name})
      : super(key: key);
}

class ChatScreenState extends State<ChatPage> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool _isComposingMessage = false;
  var _scaffoldContext;
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    if (widget.groupId != null) {
      databaseReference =
          databaseReference.child('messages/groupMessage/${widget.groupId}');
    } else {
      databaseReference = databaseReference.child('messages/personalMessage');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
          appBar: new AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            iconTheme: AppBarTheme.of(context).iconTheme,
            title: GestureDetector(
              onTap: widget.groupId != null
                  ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new GroupDetailsPage(
                              userId: widget.groupId, uid: widget.from)))
                  : () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                      child: Row(
                    children: <Widget>[
                      widget.url != null
                          ? Container(
                              height: 35.0,
                              width: 35.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(widget.url),
                                  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.circle,
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: null,
                              child: Image.asset('assets/mascot.png'),
                            ),
                      SizedBox(
                        width: 20,
                      ),
                      new Text(
                        "${widget.groupName}",
                        style: AppBarTheme.of(context).textTheme.title.copyWith(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            elevation: 0.0,
            backgroundColor: Colors.white,
          ),
          body: new Container(
            color: Colors.white,
            child: new Column(
              children: <Widget>[
                Container(
                  height: 4,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            //borderRadius: BorderRadius.circular(50),
//                              boxShadow: [BoxShadow(
//                                color: Colors.blue,
//                                blurRadius: 3.0,
//                                spreadRadius: 2.0,
//                                offset: Offset(0.0,1.0)
//                              )]
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            //borderRadius: BorderRadius.circular(50),
//                              boxShadow: [BoxShadow(
//                                  color: Colors.red,
//                                  blurRadius: 3.0,
//                                  spreadRadius: 2.0,
//                                  offset: Offset(0.0,1.0)
//                              )]
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            // borderRadius: BorderRadius.circular(50),
//                              boxShadow: [BoxShadow(
//                                  color: Colors.yellow,
//                                  blurRadius: 3.0,
//                                  spreadRadius: 2.0,
//                                  offset: Offset(0.0,1.0)
//                              )]
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            //borderRadius: BorderRadius.circular(50),
//                              boxShadow: [BoxShadow(
//                                  color: Colors.green,
//                                  blurRadius: 3.0,
//                                  spreadRadius: 2.0,
//                                  offset: Offset(0.0,1.0)
//                              )]
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                new Flexible(
                  child: new FirebaseAnimatedList(
                    query: databaseReference,
                    padding: const EdgeInsets.all(8.0),
                    reverse: true,
                    sort: (a, b) => b.key.compareTo(a.key),
                    //comparing timestamp of messages to check which one would appear first
                    itemBuilder: (_, DataSnapshot snapshot,
                        Animation<double> animation, int x) {
                      if (widget.groupId == null) {
                        if ((snapshot.value['from'] == widget.from &&
                                snapshot.value['to'] == widget.to) ||
                            (snapshot.value['to'] == widget.from &&
                                snapshot.value['from'] == widget.to)) {
                          return ChatBubble(
                            isGroup: widget.groupId != null,
                            message: snapshot,
                            fromMeBool: (widget.from == snapshot.value['from']
                                ? true
                                : false),
                          );
                        }
                      } else {
                        return ChatBubble(
                          isGroup: widget.groupId != null,
                          message: snapshot,
                          fromMeBool: (widget.from == snapshot.value['from']
                              ? true
                              : false),
                        );
                      }
                      return new SizedBox(height: 0.0);
                    },
                  ),
                ),
                //new Divider(height: 1.0),
                new Container(
                  child: _buildTextComposer(),
                ),
                new Builder(builder: (BuildContext context) {
                  _scaffoldContext = context;
                  return new Container(width: 0.0, height: 0.0);
                })
              ],
            ),
            decoration: Theme.of(context).platform == TargetPlatform.iOS
                ? new BoxDecoration(
                    border: new Border(
                        top: new BorderSide(
                    color: Colors.grey[200],
                  )))
                : null,
          )),
    );
  }

  Widget getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  Widget getDefaultSendButton() {
    return CircleAvatar(
      maxRadius: 30,
      minRadius: 15,
      backgroundColor: Colors.amber,
      child: new IconButton(
        icon: new Icon(
          Icons.send,
          color: Colors.white,
          size: 30,
        ),
        onPressed: _isComposingMessage
            ? () => _textMessageSubmitted(_textEditingController.text)
            : null,
      ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(
        color: _isComposingMessage
            ? Theme.of(context).accentColor
            : Theme.of(context).disabledColor,
      ),
      child: new Container(
        padding: EdgeInsets.only(bottom: 8.0, left: 10.0, right: 10.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 7,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]),
                    borderRadius: BorderRadius.circular(100)),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              color: Colors.white,
                            ),
                            child: new TextField(
                              autofocus: false,
                              minLines: 1,
                              maxLines: 6,
                              controller: _textEditingController,
                              onChanged: (String messageText) {
                                setState(() {
                                  _isComposingMessage = messageText.length > 0;
                                });
                              },
                              onSubmitted: _textMessageSubmitted,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintText: "Type a message",
                                  focusColor: Colors.white,
                                  hintStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.6),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  contentPadding: EdgeInsets.all(10)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 10.0,
                          left: 5,
                        ),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(40)),
                          child: new IconButton(
                              icon: new Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                File imageFile = await ImagePicker.pickImage(
                                    source: ImageSource.gallery);
                                int timestamp =
                                    new DateTime.now().millisecondsSinceEpoch;
                                StorageReference storageReference =
                                    FirebaseStorage.instance.ref().child(
                                        "img_" + timestamp.toString() + ".jpg");
                                StorageUploadTask uploadTask =
                                    storageReference.put(imageFile);
                                final StorageTaskSnapshot downloadUrl =
                                    (await uploadTask.onComplete);
                                final String url =
                                    (await downloadUrl.ref.getDownloadURL());
                                _sendMessage(messageText: null, imageUrl: url);
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 6,
            ),
            Flexible(
              flex: 1,
              child: Container(
                child: getDefaultSendButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });
    _sendMessage(messageText: text, imageUrl: null);
  }

  void _sendMessage({String messageText, String imageUrl}) {
    if (widget.groupId != null) {
      databaseReference.push().set({
        'message': messageText,
        'from': widget.from,
        'fromName': widget.name,
        'to': widget.groupId,
        'imageUrl': imageUrl,
        'timeStamp': DateTime.now().millisecondsSinceEpoch
      });
    } else {
      databaseReference.push().set({
        'message': messageText,
        'from': widget.from,
        'to': widget.to,
        'imageUrl': imageUrl,
        'timeStamp': DateTime.now().millisecondsSinceEpoch
      });
    }
  }
}
