import 'package:dsckiit_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MyTile extends StatefulWidget {
  Color color;
  String content;
  String title;
  MyTile({this.content, this.title, this.color});
  @override
  _MyTileState createState() => _MyTileState();
}

class _MyTileState extends State<MyTile> {

  double _determineFontSizeForContent(content, title) {
    int charCount = content.length + title.length ;
    double fontSize = 20 ;
    if (charCount > 110 ) { fontSize = 12; }
    else if (charCount > 80) {  fontSize = 14;  }
    else if (charCount > 50) {  fontSize = 16;  }
    else if (charCount > 20) {  fontSize = 18;  }
    return fontSize;
  }

  @override
  Widget build(BuildContext context) {

    String _content = widget.content;
    String _title = widget.title;
    double _fontSize = _determineFontSizeForContent(_content, _title);

    Widget constructChild(){
      List<Widget> contentOfTile = [];
      if(_title.length != 0) {
        contentOfTile.add(
          AutoSizeText(_title,
            style: TextStyle(fontSize: _fontSize,fontWeight: FontWeight.w900, color: widget.color),
            maxLines: _title.length == 0 ? 1 : 3,
            textScaleFactor: 1.5,
          ),
        );
        contentOfTile.add(Divider(color: Colors.transparent,height: 6,),);
      }

      contentOfTile.add(
          AutoSizeText(
            _content,
            style: TextStyle(fontSize: _fontSize-10, color: Colors.black),
            maxLines: 10,
            textScaleFactor: 1.5,)
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: contentOfTile,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(10),
      child: constructChild(),
    );
  }
}
