import 'package:flutter/material.dart';

const kHeadingStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
  color: Color(0xFF212121),
);

const kTitleStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);