import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dsckiit_app/utils/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatefulWidget {
  final DataSnapshot message;
  final bool fromMeBool,isGroup;

  ChatBubble({Key key,this.isGroup, this.message,this.fromMeBool}) : super(key: key);

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  List colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.deepOrange,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.blueGrey,
    Colors.brown,
    Colors.teal,
    Colors.deepPurple,
    Colors.pinkAccent,
    Colors.indigo,
    Colors.purple
  ];

  Random random = new Random();

  @override
  Widget build(BuildContext context) {
    final messageBody = widget.message.value['message'];
    final messageUrl = widget.message.value['imageUrl'];
    final name = widget.message.value['name'];
    var date = new DateTime.fromMillisecondsSinceEpoch(widget.message.value['timeStamp']);
    var format = new DateFormat("yMMMd");
    var format1 = new DateFormat("Hm");
    var dateString = format.format(date);
    var timeString = format1.format(date);
    bool fromMe = widget.fromMeBool;
    return Align(
      alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
              gradient: fromMe ? chatBubbleGradient : chatBubbleGradient2,
              borderRadius: fromMe
                  ? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ) : BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            constraints: BoxConstraints(
              minHeight: 30.0,
              minWidth: 30.0,
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget.isGroup && (!fromMe) ? Text(
                  widget.message.value['authorName'],
                  style: TextStyle(
                    color: colors[random.nextInt(12)],
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ): new SizedBox(
                  height: 0,
                ),
                fromMe ? new SizedBox(
                  height: 0.0,
                ) : new SizedBox(
                  height: 3,
                ),
                messageBody == null ?
                new Hero(
                    tag: messageUrl,
                    child: new GestureDetector(
//                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => new ImagePage(url: messageUrl,))),
                      child: new Padding(
                        padding: EdgeInsets.all(4),
                        child: new Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          height: 250.0,
                          padding: EdgeInsets.all(4),
                          alignment: Alignment.center,
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(messageUrl),
                                fit: BoxFit.fill
                            ),
                          ),
                        ),
                      ),
                    )
                ): Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    messageBody,
                    style: TextStyle(
                      color: fromMe ? Colors.white : Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            timeString,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 5)
        ],
      ),
    );
  }
}