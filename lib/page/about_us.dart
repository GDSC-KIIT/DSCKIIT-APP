import 'dart:math';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dsckiit_app/constants.dart';
import 'package:dsckiit_app/page/developers.dart';
import 'package:dsckiit_app/page/image_page.dart';
import 'package:dsckiit_app/utils/tools.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
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
      body: SingleChildScrollView(
              child: Stack(
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
                          // new WidgetSpan(
                          //   child: ColorizeAnimatedTextKit(
                          //       totalRepeatCount: 1,
                          //       speed: Duration(milliseconds: 500),
                          //       onTap: () => Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) => new Developers()),
                          //           ),
                          //       text: ["developer"],
                          //       textStyle: TextStyle(
                          //           fontSize: 17, fontFamily: "GoogleSans"),
                          //       colors: [
                          //         Colors.black,
                          //         Colors.blue,
                          //         Colors.green,
                          //         Colors.red,
                          //       ],
                          //       textAlign: TextAlign.start,
                          //       alignment:
                          //           Alignment.topLeft // or Alignment.topLeft
                          //       ),
                          // ),
                          new WidgetSpan(
                            child: Shimmer.fromColors(
                              baseColor: Colors.black,
                              highlightColor:
                                  Tools.multiColors[Random().nextInt(4)],
                              period: Duration(milliseconds: 2000),
                              loop: 2,
                              child: GestureDetector(
                                child: Text(
                                  'developer',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17, fontFamily: "GoogleSans"),
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => new Developers()),
                                ),
                              ),
                            ),
                          ),
                          new TextSpan(
                              text:
                                  " communities and supports them with commencing student clubs on their campuses. "),
                          // new WidgetSpan(
                          //   child: ColorizeAnimatedTextKit(
                          //       totalRepeatCount: 1,
                          //       speed: Duration(milliseconds: 500),
                          //       onTap: () => Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) => new Developers()),
                          //           ),
                          //       text: ["Developer"],
                          //       textStyle: TextStyle(
                          //           fontSize: 17, fontFamily: "GoogleSans"),
                          //       colors: [
                          //         Colors.black,
                          //         Colors.blue,
                          //         Colors.amber,
                          //         Colors.green,
                          //       ],
                          //       textAlign: TextAlign.start,
                          //       alignment:
                          //           Alignment.topLeft // or Alignment.topLeft
                          //       ),
                          // ),
                          new WidgetSpan(
                            child: Shimmer.fromColors(
                              baseColor: Colors.black,
                              highlightColor:
                                  Tools.multiColors[Random().nextInt(4)],
                              period: Duration(milliseconds: 2500),
                              loop: 2,
                              child: GestureDetector(
                                child: Text(
                                  'Developer',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17, fontFamily: "GoogleSans"),
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => new Developers()),
                                ),
                              ),
                            ),
                          ),
                          new TextSpan(
                              text:
                                  " Student Clubs is a program that recognizes and supports university students who are excited about growing "),
                          // new WidgetSpan(
                          //   child: ColorizeAnimatedTextKit(
                          //       totalRepeatCount: 1,
                          //       speed: Duration(milliseconds: 500),
                          //       onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => new Developers()),),
                          //       text: ["developer"],
                          //       textStyle: TextStyle(
                          //           fontSize: 17, fontFamily: "GoogleSans"),
                          //       colors: [
                          //         Colors.black,
                          //         Colors.red,
                          //         Colors.blue,
                          //         Colors.amber,
                          //       ],
                          //       textAlign: TextAlign.start,
                          //       alignment:
                          //           Alignment.topLeft // or Alignment.topLeft
                          //       ),
                          // ),
                          new WidgetSpan(
                            child: Shimmer.fromColors(
                              baseColor: Colors.black,
                              highlightColor:
                                  Tools.multiColors[Random().nextInt(4)],
                              loop: 2,
                              period: Duration(milliseconds: 3000),
                              child: GestureDetector(
                                child: Text(
                                  'developer',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17, fontFamily: "GoogleSans"),
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => new Developers()),
                                ),
                              ),
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
                          icon: Icon(FontAwesomeIcons.solidEnvelope),
                          onPressed: () async {
                            var emailUrl =
                                '''mailto:dsckiit@gmail.com?subject=Support Needed For DevExpo App''';
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
      ),
    );
  }
}
