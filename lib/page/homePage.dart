import 'dart:async';
import 'package:dsckiit_app/model/project.dart';
import 'package:dsckiit_app/page/chat_container.dart';
import 'package:dsckiit_app/page/media_page.dart';
import 'package:dsckiit_app/services/crud.dart';
import 'package:dsckiit_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dsckiit_app/Widgets/custom_event_card.dart';
import 'package:dsckiit_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsckiit_app/page/account_page.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:line_icons/line_icons.dart';
import 'package:dsckiit_app/screen/notification_screen.dart';
import 'package:dsckiit_app/projects/addProject.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;
  bool isSignedIn = false;

  ScrollController scrollController;
  bool dialVisible = true;


  List<Project> items;
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  StreamSubscription<QuerySnapshot> projectSub;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "/OpeningPage");
      }
    });
  }

  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isSignedIn = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getUser();

    items = new List();

    projectSub?.cancel();
    projectSub = db.getProjectList().listen((QuerySnapshot snapshot) {
      final List<Project> project = snapshot.documents
          .map((documentSnapshot) => Project.fromMap(documentSnapshot.data))
          .toList();

      setState(() {
        this.items = project;
      });
    });

    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  void _deleteProject(
      BuildContext context, Project project, int position) async {
    db.deleteProject(project.id).then((project) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToProject(BuildContext context, Project project) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProjectScreen(project)),
    );
  }

  void _createNewProject(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProjectScreen(Project(null, '', ''))),
    );
  }

  void _launchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.accessibility, color: Colors.white),
          backgroundColor: Colors.deepOrange,
          onTap: () => _createNewProject(context),
          label: 'New Project',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.brush, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => NotificationScreen(),
          label: 'New Note',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
      ],
    );
  }

  static const String urlToMentorPage = "https://dsckiit.tech/mentors.html";
  static const String urlToTeamPage = "https://dsckiit.tech/team.html";

  int _currentNavBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.grey);
    final tabs = [
      Builder(
        builder:(context) => SingleChildScrollView(
          child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 7.0,
                        child: Container(
                          height: 55,
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: IconButton(
                                  onPressed: () {
                                      Scaffold.of(context).openDrawer();
                                  },
                                  icon: Icon(
                                    Icons.menu,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.go,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                      hintText: "Search..."),
                                ),
                              ),
                              !isSignedIn
                                  ? CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/animator.gif"),
                                    backgroundColor: Colors.transparent,
                                  )
                                  : Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: CircleAvatar(
                                      backgroundImage: user.photoUrl != null
                                          ? NetworkImage(user.photoUrl)
                                          : AssetImage('assets/mascot.png'),
//                                      backgroundImage: AssetImage('assets/mascot.svg'),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Ongoing",
                            style: kHeadingStyle,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Colors.grey[900],
                            ),
                            iconSize: 27,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 150,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        itemBuilder: (context, position) {
                          return GestureDetector(
                            onTap: () =>
                                _navigateToProject(context, items[position]),
                            onLongPress: () =>
                                _deleteProject(context, items[position], position),
                            child: Card(
                              margin: EdgeInsets.only(right: 5, left: 10),
                              color: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                width: 200,
                                height: 100,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('${items[position].projectName}',
                                          style: kTitleStyle.copyWith(
                                            color: Colors.white,
                                          )),
                                      Text(
                                        "${items[position].number} members",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                        ),
                                      ),
                                      // IconButton(
                                      //     icon: const Icon(Icons.remove_circle_outline),
                                      //     onPressed: () => _deleteProject(
                                      //         context, items[position], position)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Events and Schedules",
                            style: kHeadingStyle,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Colors.grey[900],
                            ),
                            iconSize: 27,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 150,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection('events').snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return new Text('Error: ${snapshot.error}');
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator());
                            default:
                              return new ListView(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                  return new CustomEventCard(
                                    title: document['title'],
                                    imgURL: document['image'],
                                    date: document['date'],
                                    registerUrl: document['register'],
                                  );
                                }).toList(),
                              );
                          }
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ), // Home screen
      !isSignedIn
          ? CircularProgressIndicator()
          : ChatContainer(
              uid: user.uid ?? "",
            ),
      NotificationScreen(),
      AccountPage(user: user),
    ];

    return SafeArea(
      child: Scaffold(
        body: tabs[_currentNavBarIndex],
        floatingActionButton: _currentNavBarIndex != 0
            ? null
            //: buildSpeedDial(),
            : FloatingActionButton(
                backgroundColor: kFabColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () => _createNewProject(context),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 10,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 35,
          unselectedIconTheme: IconThemeData(size: 30),
          currentIndex: _currentNavBarIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                LineIcons.home,
                color: Colors.black45,
              ),
              title: Text("Home"),
              activeIcon: Icon(
                LineIcons.home,
                color: Colors.black,
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  LineIcons.comments,
                  color: Colors.black45,
                ),
                title: Text("Messages"),
                activeIcon: Icon(
                  LineIcons.comments,
                  color: Colors.amber,
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  LineIcons.bell,
                  color: Colors.black45,
                ),
                title: Text("Notifications"),
                activeIcon: Icon(
                  LineIcons.bell,
                  color: Colors.black,
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  LineIcons.user,
                  color: Colors.black45,
                ),
                title: Text("Account"),
                activeIcon: Icon(
                  LineIcons.user,
                  color: Colors.black,
                )),
          ],
          onTap: (index) {
            setState(() {
              _currentNavBarIndex = index;
            });
          },
        ),
        drawer: Drawer(
          child: !isSignedIn
              ? CircularProgressIndicator()
              : ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text(
                        '${user.displayName}',
                        style: TextStyle(fontSize: 20),
                      ),
                      accountEmail: Text(
                        '${user.email}',
                        style: TextStyle(fontSize: 13),
                      ),
                      decoration: BoxDecoration(color: Color(0xFF183E8D)),
                      currentAccountPicture: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 50,
                          backgroundImage: user.photoUrl != null
                              ? NetworkImage(user.photoUrl)
                              : AssetImage("assets/mascot.png")),
                    ),
                    ListTile(
                      title: Text("Mentors"),
                      trailing: Icon(Icons.person),
                      onTap: () {
                        _launchUrl(urlToMentorPage);
                      },
                    ),
                    ListTile(
                      title: Text("Team"),
                      trailing: Icon(Icons.group),
                      onTap: () {
                        _launchUrl(urlToTeamPage);
                      },
                    ),
                    ListTile(
                      title: Text("Noticeboard"),
                      trailing: Icon(Icons.photo),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MediaPage()));
                      },
                    ),
                    ListTile(
                      title: Text("Feedback Form"),
                      trailing: Icon(Icons.feedback),
                      onTap: () {},
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Close"),
                      trailing: Icon(Icons.close),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
class FloatAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 10,
          right: 15,
          left: 15,
          child: Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Material(
                  type: MaterialType.transparency,
                  child: IconButton(
                    splashColor: Colors.grey,
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        hintText: "Search..."),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}