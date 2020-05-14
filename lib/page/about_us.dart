import 'dart:ui';

import 'package:dsckiit_app/page/image_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  void _launchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("About Us"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/logo.png'),
                    fit: BoxFit.fitWidth)),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey.withOpacity(0.1),
                  child: Container(),
                ),
              ),
            ),
          ),
          Center(
            child: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.facebookF),
                    onPressed: () async {
                      await _launchUrl("https://facebook.com/dsckiit");
                    },
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.twitter),
                    onPressed: () async {
                      await _launchUrl("https://twitter.com/dsckiit");
                    },
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.linkedinIn),
                    onPressed: () async {
                      _launchUrl("https://linkedin.com/in/dsckiit");
                    },
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.youtube),
                    onPressed: () async {
                      await _launchUrl("https://youtube.com/dsckiit");
                    },
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.instagram),
                    onPressed: () async {
                      await _launchUrl("https://instagram.com/dsckiit");
                    },
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.envelope),
                    onPressed: () async {
                      var emailUrl =
                          '''mailto:dsckiit@gmail.com?subject=Support Needed For DevExpo App&body={Name: Sayan Nath},Email: dsckiit@gmail.com}''';
                      var out = Uri.encodeFull(emailUrl);
                      await _launchUrl(out);
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
