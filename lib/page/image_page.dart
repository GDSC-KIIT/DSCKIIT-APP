import 'package:flutter/material.dart';
//import 'package:pinch_zoom_image/pinch_zoom_image.dart';

class ImagePage extends StatefulWidget {
  final String url;
  ImagePage({Key key,this.url}) : super(key:key);
  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: widget.url,
        child: Center(
          child: Image.network(widget.url),
        ),
      ),
    );
  }
}