import 'package:flutter/material.dart';
import 'package:dsckiit_app/constants.dart';
//import 'package:url_launcher/url_launcher.dart';

class CustomEventCard extends StatelessWidget {
  CustomEventCard(
      {this.title, this.imgURL, this.members = 0, this.date, this.registerUrl});

  String title, imgURL;
  int members;
  String date;
  String registerUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildAboutDialog(context, title, imgURL, date, registerUrl),
        );
      },
      child: Card(
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
      ),
    );
  }
}

Widget _buildAboutDialog(BuildContext context, String title, String imgURL,
    String date, String registerUrl) {
  return new AlertDialog(
    title: Text(title),
    titleTextStyle: kHeadingStyle,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image(
          image: NetworkImage(imgURL),
          height: 80,
          width: 200,
        ),
        SizedBox(
          height: 10,
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
    actions: <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme
            .of(context)
            .primaryColor,
        child: const Text('OKAY!  '),
      ),
      FlatButton(
        onPressed: () {
          //_launchURL(registerUrl);
        },
        textColor: Theme
            .of(context)
            .primaryColor,
        child: const Text('REGISTER'),
      ),
    ],
  );
}

//_launchURL(String url1) async {
//  String url = url1;
//  if (await canLaunch(url)) {
//    await launch(url);
//  } else {
//    throw 'Could not launch $url';
//  }
//}
