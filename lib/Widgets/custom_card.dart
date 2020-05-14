import 'package:dsckiit_app/constants.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  CustomCard({this.title, this.members = 0, this.color});

  String title;
  int members;
  var color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(right: 5, left: 10),
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        width: 200,
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title,
                  style: kTitleStyle.copyWith(
                    color: Colors.white,
                  )),
              Text(
                members != 0 ? "$members members" : "",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
