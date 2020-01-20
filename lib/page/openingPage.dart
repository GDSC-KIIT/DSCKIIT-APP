import 'package:dsckiit_app/Widgets/rounded_button.dart';
import 'package:dsckiit_app/page/homePage.dart';
import 'package:flutter/material.dart';
import 'package:dsckiit_app/page/SignUpPage.dart';
import 'package:dsckiit_app/page/SignInPage.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

final kFirebaseAnalytics = FirebaseAnalytics();

class OpeningPage extends StatefulWidget {
  @override
  _OpeningPageState createState() => _OpeningPageState();
}

class _OpeningPageState extends State<OpeningPage> {
  FirebaseUser _user;
  // If this._busy=true, the buttons are not clickable. This is to avoid
  // clicking buttons while a previous onTap function is not finished.
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then(
          (user) => setState(() => this._user = user),
        );
  }

  // Sign in with Google.
  Future<FirebaseUser> _googleSignIn() async {
    final curUser = this._user ?? await FirebaseAuth.instance.currentUser();
    if (curUser != null && !curUser.isAnonymous) {
      return curUser;
    }
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Note: user.providerData[0].photoUrl == googleUser.photoUrl.
    final user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    kFirebaseAnalytics.logLogin();
    setState(() => this._user = user);
    return user;
  }

  Future<Null> _signOut() async {
    final user = await FirebaseAuth.instance.currentUser();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(user == null
            ? 'No user logged in.'
            : '"${user.displayName}" logged out.'),
      ),
    );
    FirebaseAuth.instance.signOut();
    setState(() => this._user = null);
  }

  void _showUserProfilePage(FirebaseUser user) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return HomePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.grey);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 150,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Image.asset(
                        'assets/writting.png',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RoundedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                          return SignupPage();
                        }));
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      text: 'Sign up',
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    RoundedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                          return SigninPage();
                        }));
                      },
                      color: Colors.grey[50],
                      textColor: Colors.black,
                      text: 'Sign in',
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.only(top: 50),
                ),
                Center(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: this._busy
                        ? null
                        : () async {
                            setState(() => this._busy = true);
                            final user = await this._googleSignIn();
                            this._showUserProfilePage(user);
                            setState(() => this._busy = false);
                          },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFB00020),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Log in With Gmail',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// builder: (ctx) => Scaffold(
//   appBar: AppBar(
//     title: Text('user profile'),
//   ),
//   body: ListView(
//     children: <Widget>[
//       ListTile(title: Text('User id: ${user.uid}')),
//       ListTile(title: Text('Display name: ${user.displayName}')),
//       ListTile(title: Text('Anonymous: ${user.isAnonymous}')),
//       ListTile(title: Text('providerId: ${user.providerId}')),
//       ListTile(title: Text('Email: ${user.email}')),
//       ListTile(
//         title: Text('Profile photo: '),
//         trailing: user.photoUrl != null
//             ? CircleAvatar(
//                 backgroundImage: NetworkImage(user.photoUrl),
//               )
//             : CircleAvatar(
//                 child: Text(user.displayName[0]),
//               ),
//       ),
//       ListTile(
//         title: Text('Last sign in: ${user.metadata.lastSignInTime}'),
//       ),
//       ListTile(
//         title: Text('Creation time: ${user.metadata.creationTime}'),
//       ),
//       ListTile(title: Text('ProviderData: ${user.providerData}')),
//     ],
//   ),
// ),
