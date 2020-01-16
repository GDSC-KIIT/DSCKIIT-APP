import 'package:flutter/material.dart';
import 'package:dsckiit_app/constants.dart';

class CustomEventCard extends StatelessWidget {
  CustomEventCard({this.title, this.imgURL, this.members = 0, this.date});

  String title, imgURL;
  int members;
  String date;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(right: 5, left: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        width: 200,
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image(
                image: NetworkImage(imgURL),
                height: 80,
                width: 200,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: kTitleStyle.copyWith(
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                date,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
