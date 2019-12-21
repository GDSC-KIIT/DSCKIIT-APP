import 'package:flutter/material.dart';
import 'package:dsckiit_app/constants.dart';

class CustomEventCard extends StatelessWidget {
  CustomEventCard({this.title, this.members = 0, this.date});

  String title;
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
                image: NetworkImage(
                    "https://media.licdn.com/dms/image/C561BAQHF4693xVe78g/company-background_10000/0?e=2159024400&v=beta&t=UUZZCViH2CPkraPz1YZhf121oS_Nonr6xuH5hyEqX1g"),
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
