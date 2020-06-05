import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dsckiit_app/page/image_page.dart';
import 'package:dsckiit_app/utils/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatefulWidget {
  final DataSnapshot message;
  final bool fromMeBool, isGroup;
  final String toUrl;

  ChatBubble(
      {Key key,
      this.isGroup,
      this.message,
      this.fromMeBool,
      this.toUrl,})
      : super(key: key);

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  List colors = [Colors.red, Colors.green, Colors.blue, Colors.yellow];

  Random random = new Random();
  bool _isPressed = false;

  void _showTime(){
    setState(() {
      _isPressed = ! _isPressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final messageBody = widget.message.value['message'];
    final messageUrl = widget.message.value['imageUrl'];
    var date = new DateTime.fromMillisecondsSinceEpoch(
        widget.message.value['timeStamp']);
    var format = new DateFormat("yMMMd");
    var format1 = new DateFormat("Hm");
    var dateString = format.format(date);
    var timeString = format1.format(date);
    bool fromMe = widget.fromMeBool;
    return GestureDetector(
          onTap: _showTime,
          onLongPress: () async {
            if(fromMe && !widget.isGroup){
              final result = await showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text("Delete message?"),
                      content: Text(messageBody ?? 'Image'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Yes"),
                          onPressed: (){
                            Navigator.of(context).pop(true);
                          },
                        ),
                        FlatButton(
                          child: Text("No"),
                          onPressed: (){
                            Navigator.of(context).pop(false);
                          },
                        )
                      ],
                    );
                  }
              );
              if(result){
                await FirebaseDatabase.instance.reference().child('messages').child('personalMessage').child(widget.message.key).remove();
              }
            }
          },
          child: Align(
              alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: fromMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      fromMe
                          ? SizedBox()
                          : widget.toUrl != null
                              ? Container(
                                  height: 35.0,
                                  width: 35.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(widget.toUrl),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : Container(
                        height: 35.0,
                        width: 35.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/mascot.png"),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      )
                      ,
                      SizedBox(width: 5,),
                      Column(
                        crossAxisAlignment: fromMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,

                        children: <Widget>[
                          widget.isGroup && (!fromMe)
                              ? Text(
                                  widget.message.value['fromName'],
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    // Was causing errors when you were sending the image.
                                    fontSize: 13.2,
                                  ),
                                )
                              : new SizedBox(
                                  height: 0,
                                ),
                          fromMe
                              ? new SizedBox(
                                  height: 0.0,
                                )
                              : new SizedBox(
                                  height: 1,
                                ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: fromMe ? Color(0xFFCEDDEF) : Colors.grey[200],
//                            gradient: fromMe ? chatBubbleGradient : null,
                              borderRadius: fromMe
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      bottomLeft: Radius.circular(12.0),
                                      bottomRight: Radius.circular(12.0),
                                    )
                                  : BorderRadius.only(
                                      topRight: Radius.circular(12.0),
                                      bottomLeft: Radius.circular(12.0),
                                      bottomRight: Radius.circular(12.0),
                                    ),
                            ),
                            constraints: BoxConstraints(
                              minHeight: 30.0,
                              minWidth: 30.0,
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                messageBody == null
                                    ? new Hero(
                                        tag: messageUrl,
                                        child: new GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => new ImagePage(
                                                        url: messageUrl,
                                                      ))),
                                          child: new Padding(
                                            padding: EdgeInsets.all(4),
                                            child: new Container(
                                              height: 250,
                                              padding: EdgeInsets.all(4),
                                              alignment: Alignment.center,
                                              decoration: new BoxDecoration(
                                                image: DecorationImage(
                                                  image: CachedNetworkImageProvider(
                                                      messageUrl),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Text(
                                          messageBody,
                                          style: TextStyle(
                                            color:
                                                fromMe ? Color(0xFF182952) : Colors.black87,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          _isPressed ? Text(
                            timeString,
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 14.0,
                            ),
                          ) : SizedBox(),
                          SizedBox(height: 10)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
        );
  }
}
