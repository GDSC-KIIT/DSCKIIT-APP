import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dsckiit_app/page/chat_bubble.dart';
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
  final String to,from,groupName,groupId,url,uid;
  ChatPage({Key key,this.to,this.from,this.groupId,this.url,this.groupName,this.uid}): super(key:key);
}

class ChatScreenState extends State<ChatPage> {
  final TextEditingController _textEditingController = new TextEditingController();
  bool _isComposingMessage = false;
  var _scaffoldContext;
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    if(widget.groupId!=null){
      databaseReference = databaseReference.child('messages/groupMessage/${widget.groupId}');
    }else{
      databaseReference = databaseReference.child('messages/personalMessage');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                  child: Row(
                    children: <Widget>[
                      widget.url !=null ?
                      Container(
                        height: 35.0,
                        width: 35.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(widget.url),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ) : CircleAvatar(
                        backgroundColor: null,
                        child: Image.asset('assets/professional.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Text("${widget.groupName}",style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  )
              ),
            ],
          ),
          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: new FirebaseAnimatedList(
                  query: databaseReference,
                  padding: const EdgeInsets.all(8.0),
                  reverse: true,
                  sort: (a, b) => b.key.compareTo(a.key),
                  //comparing timestamp of messages to check which one would appear first
                  itemBuilder: (_, DataSnapshot snapshot,
                      Animation<double> animation, int x) {
//                    return new ListTile(
//                      subtitle: new Text(snapshot.value['message']),
//                    );
                  if(widget.groupId == null) {
                    if ((snapshot.value['from'] == widget.from  &&
                        snapshot.value['to'] == widget.to) ||
                        (snapshot.value['to'] == widget.from &&
                        snapshot.value['from'] == widget.to)) {
                      return ChatBubble(isGroup: widget.groupId != null,
                        message: snapshot,
                        fromMeBool: (widget.from == snapshot.value['from']
                            ? true
                            : false),
                      );
                    }
                  } else {
                    return ChatBubble(isGroup: widget.groupId != null,
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
              new Divider(height: 1.0),
              new Container(
                decoration:
                new BoxDecoration(color: Theme.of(context).cardColor),
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
        ));
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
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
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
          ),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(
                      Icons.photo_camera,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () async {
                      File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
                      int timestamp = new DateTime.now().millisecondsSinceEpoch;
                      StorageReference storageReference = FirebaseStorage
                          .instance
                          .ref()
                          .child("img_" + timestamp.toString() + ".jpg");
                      StorageUploadTask uploadTask = storageReference.put(imageFile);
                      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
                      final String url = (await downloadUrl.ref.getDownloadURL());
                      _sendMessage(
                          messageText: null, imageUrl: url);
                    }),
              ),
              new Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                  child: new TextField(
                    controller: _textEditingController,
                    onChanged: (String messageText) {
                      setState(() {
                        _isComposingMessage = messageText.length > 0;
                      });
                    },
                    onSubmitted: _textMessageSubmitted,
                    decoration:
                    new InputDecoration.collapsed(
                        hintText: "Type a message",
                        focusColor: Colors.white,
                        hintStyle:  TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontWeight: FontWeight.w600,
                    )),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? getIOSSendButton()
                    : getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });
    _sendMessage(messageText: text, imageUrl: null);
  }

  void _sendMessage({String messageText, String imageUrl}) {
    databaseReference.push().set({
      'message': messageText ,
      'from': widget.from,
      'to': widget.to,
      'timeStamp': DateTime.now().millisecondsSinceEpoch
    });
  }
}