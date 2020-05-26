import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dsckiit_app/constants.dart';
import 'package:dsckiit_app/page/image_page.dart';
import 'package:flutter/gestures.dart';
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
//           Container(
//             constraints: BoxConstraints.expand(),
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage('assets/logo.png'),
//                     fit: BoxFit.fitWidth)),
//             child: ClipRRect(
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//                 child: Container(
//                   alignment: Alignment.center,
//                   color: Colors.grey.withOpacity(0.1),
//                   child: Container(),
//                 ),
//               ),
//             ),
//           ),
          Column(
            children: <Widget>[
              Container(
                color: Colors.transparent,
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Image(
                    image: AssetImage('assets/dsckiitLogo.png'),
                    height: 200.0,
                  ),
//                child: Column(
//                  children: <Widget>[
//                    Text("Developer Student Clubs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
//                    Text("Kalinga Institute of Industrial Technology")
//                  ],
//                ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                width: MediaQuery.of(context).size.width * 0.9,
                child: RichText(
                  text: new TextSpan(
                      text:
                          "Google collaborates with university students who are enthusiastic about growing ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'GoogleSans'),
                      children: [
                        new WidgetSpan(
                          child: ColorizeAnimatedTextKit(
                              totalRepeatCount: 2,
                              speed: Duration(milliseconds: 2000),
                              onTap: () {
                                print("Tap Event");
                              },
                              text: ["developer"],
                              textStyle: TextStyle(
                                  fontSize: 17, fontFamily: "GoogleSans"),
                              colors: [
                                Colors.black,
                                Colors.blue,
                                Colors.green,
                                Colors.red,
                              ],
                              textAlign: TextAlign.start,
                              alignment:
                                  Alignment.topLeft // or Alignment.topLeft
                              ),
                        ),
                        new TextSpan(
                            text:
                                " communities and supports them with commencing student clubs on their campuses. "),
                        new WidgetSpan(
                          child: ColorizeAnimatedTextKit(
                              totalRepeatCount: 2,
                              speed: Duration(milliseconds: 2000),
                              onTap: () {
                                print("Tap Event");
                              },
                              text: ["Developer"],
                              textStyle: TextStyle(
                                  fontSize: 17, fontFamily: "GoogleSans"),
                              colors: [
                                Colors.black,
                                Colors.blue,
                                Colors.amber,
                                Colors.green,
                              ],
                              textAlign: TextAlign.start,
                              alignment:
                                  Alignment.topLeft // or Alignment.topLeft
                              ),
                        ),
                        new TextSpan(
                            text:
                                " Student Clubs is a program that recognizes and supports university students who are excited about growing "),
                        new WidgetSpan(
                          child: ColorizeAnimatedTextKit(
                              totalRepeatCount: 2,
                              speed: Duration(milliseconds: 2000),
                              onTap: () {
                                print("Tap Event");
                              },
                              text: ["developer"],
                              textStyle: TextStyle(
                                  fontSize: 17, fontFamily: "GoogleSans"),
                              colors: [
                                Colors.black,
                                Colors.red,
                                Colors.blue,
                                Colors.amber,
                              ],
                              textAlign: TextAlign.start,
                              alignment:
                                  Alignment.topLeft // or Alignment.topLeft
                              ),
                        ),
                        new TextSpan(
                            text:
                                " communities that cultivate learning, sharing and collaboration."),
                      ]),
                  textAlign: TextAlign.justify,
                  maxLines: 12,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 20.0,
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
                        icon: Icon(FontAwesomeIcons.globeAmericas),
                        onPressed: () async {
                          await _launchUrl("https://dsckiit.tech");
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.mail,
                          size: 32,
                        ),
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
              ),
            ],
          )
        ],
      ),
    );
  }
}
