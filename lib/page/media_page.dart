import 'package:flutter/material.dart';
import 'package:dsckiit_app/Widgets/google_button.dart';

class MediaPage extends StatefulWidget {
  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBarTheme.of(context).color,
        iconTheme: AppBarTheme.of(context).iconTheme,
        title: Text(
          "Noticeboard",
          style: AppBarTheme.of(context).textTheme.title,
        ),
        centerTitle: true,
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: CustomPaint(
            child: Container(),
            foregroundPainter: FloatingPainterGButton(),
          ),
          onPressed: () {}),
    );
  }
}