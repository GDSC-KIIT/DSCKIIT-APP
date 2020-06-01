import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dsckiit_app/model/developer.dart';
import 'package:dsckiit_app/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Developers extends StatefulWidget {
  @override
  _DevelopersState createState() => _DevelopersState();
}

class _DevelopersState extends State<Developers> {

  List<Developer> developers = [
  Developer(
    speakerImage: "https://i.ibb.co/vjrQvLV/Whats-App-Image-2020-05-29-at-12-42-43-AM.jpg",
    speakerName: "Aman Sahu",
    speakerDesc: "Flutter Team, DSC KIIT",
    speakerSession: "Team Lead and the Flutter UI Guru for this project.",
    fbUrl: "https://www.facebook.com/AmanSahu.2000",
    githubUrl: "https://github.com/amansahu278",
    linkedinUrl: "https://www.linkedin.com/in/aman-sahu-7602931a3",
    twitterUrl: "https://www.twitter.com/A_ManSahu",
    instagramUrl: "https://www.instagram.com/someone_named_aman",
  ),
  Developer(
    speakerImage: "https://dsckiit.tech/assets/img/team-image/Sayan_Nath_ML_FLUTTER.jpg",
    speakerName: "Sayan Nath",
    speakerDesc: "Multiple Teams, DSC KIIT",
    speakerSession: "The multi manager, overly enthu and the 'Han bhaiya, ho jayega.' of the lot.",
    fbUrl: "https://www.facebook.com/sayan.nath.549",
    githubUrl: "https://github.com/sayannath",
    linkedinUrl: "https://bit.ly/SayanNath",
  ),
  Developer(
    speakerImage: "https://img.freepik.com/free-vector/happy-smiling-genie-appearing-from-magic-lamp_102811-9.jpg?size=338&ext=jpg",
    speakerName: "John Doe",
    speakerDesc: "An Anonymous Genie",
    speakerSession: "I came silently, implemented the chat features and made the app production ready. Who am I?",
  ),
  Developer(
    speakerImage: "https://dsckiit.tech/assets/img/team-image/Mayukh_Mallick_UIUX.jpg",
    speakerName: "Mayukh Mallick",
    speakerDesc: "UI/UX Team, DSC KIIT",
    speakerSession: "The go to 'Login Page ka design chahiye', 'Chat Page ka design chahiye', 'Meri girlfriend ka portrait chahiye' person.",
    fbUrl: "https://www.facebook.com/mayukh.mallick.39",
    githubUrl: "https://github.com/mallick370",
    linkedinUrl: "https://www.linkedin.com/in/mayukh-mallick-a7460916b/",
    behanceUrl: "https://www.behance.net/mayukhmallick",
  ),
  Developer(
    speakerImage: "https://i.ibb.co/G0ryQ1B/pp.jpg",
    speakerName: "Amrit Dash",
    speakerDesc: "Core Team, DSC KIIT",
    speakerSession: "Mentor, Creative Contributor and the guy who made this page.",
    fbUrl: "https://www.facebook.com/ddash123",
    githubUrl: "https://github.com/the-AoG-guy/",
    linkedinUrl: "https://linkedin.com/in/amritdash60/",
    twitterUrl: "https://twitter.com/the_AoG_guy",
    instagramUrl: "https://www.instagram.com/_amrit_dash_/",
  ),
  Developer(
    speakerImage: "https://dsckiit.tech/assets/img/team-image/Akash_Sharma_Graphic%20Design.jpeg",
    speakerName: "Akash Sharma",
    speakerDesc: "Core Team, DSC KIIT",
    speakerSession: "Design Mentor, Full time assets folder and the color pallete of the project.",
    fbUrl: "https://www.facebook.com/profile.php?id=100002220854105",
    githubUrl: "https://github.com/akashsharma99/",
    linkedinUrl: "https://www.linkedin.com/in/akashsharma99",
  ),
];

  Widget socialActions(context, Developer developer) => FittedBox(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if(developer.fbUrl != null) IconButton(
              icon: Icon(
                FontAwesomeIcons.facebookF,
                size: 15,
              ),
              onPressed: () {
                launch(developer.fbUrl);
              },
            ),
            if(developer.instagramUrl != null) IconButton(
              icon: Icon(
                FontAwesomeIcons.instagram,
                size: 15,
              ),
              onPressed: () {
                launch(developer.instagramUrl);
              },
            ),
            if(developer.twitterUrl != null) IconButton(
              icon: Icon(
                FontAwesomeIcons.twitter,
                size: 15,
              ),
              onPressed: () {
                launch(developer.twitterUrl);
              },
            ),
            if(developer.githubUrl != null) IconButton(
              icon: Icon(
                FontAwesomeIcons.linkedinIn,
                size: 15,
              ),
              onPressed: () {
                launch(developer.linkedinUrl);
              },
            ) else IconButton(
              icon: Icon(
                FontAwesomeIcons.question,
                size: 15,
              ),
              onPressed: () {
                setState(() {
                  developers[2].speakerImage = "https://dsckiit.tech/assets/img/team-image/GAURAV_BHIWANIWALA_android_flutter.jpg";
                  developers[2].speakerName = "Gaurav Bhiwaniwala";
                  developers[2].speakerDesc = "Android Team, DSC KIIT";
                  developers[2].speakerSession = "Yeah you guessed it right. I'm the chats genie.";
                  developers[2].githubUrl = "https://github.com/gau187";
                  developers[2].linkedinUrl = "https://www.linkedin.com/in/gaurav-bhiwaniwala-ba787664";
                });
              },
            ),
            if(developer.githubUrl != null) IconButton(
              icon: Icon(
                FontAwesomeIcons.github,
                size: 15,
              ),
              onPressed: () {
                launch(developer.githubUrl);
              },
            ),
            if(developer.behanceUrl != null) IconButton(
              icon: Icon(
                FontAwesomeIcons.behance,
                size: 15,
              ),
              onPressed: () {
                launch(developer.behanceUrl);
              },
            ),
          ],
        ),
      );

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text("Contributors"),
          elevation: 0.0,
          centerTitle: true,
        ),
        body: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (c, i) {
          return Card(
            elevation: 0.0,
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints.expand(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: developers[i].speakerImage,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                developers[i].speakerName,
                                style: Theme.of(context).textTheme.title,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              AnimatedContainer(
                                duration: Duration(seconds: 1),
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: 5,
                                color: Tools.multiColors[Random().nextInt(4)],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            developers[i].speakerDesc,
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            developers[i].speakerSession,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          socialActions(context, developers[i]),
                        ],
                      ),
                    )
                  ],
                )),
          );
        },
        itemCount: developers.length,
      ),
    );
  }
}


