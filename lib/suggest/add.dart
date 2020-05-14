import 'package:dsckiit_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:dsckiit_app/model/suggest.dart';
import 'package:dsckiit_app/services/suggest_crud.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class SuggestScreen extends StatefulWidget {
  final Suggest project;
  SuggestScreen(this.project);

  @override
  State<StatefulWidget> createState() => new _SuggestScreenState();
}

class _SuggestScreenState extends State<SuggestScreen> {
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  TextEditingController _pnController;
  TextEditingController _nuController;

  @override
  void initState() {
    super.initState();

    _pnController = new TextEditingController(text: widget.project.projectName);
    _nuController = new TextEditingController(text: widget.project.number);
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color(0xFF183E8D));
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Suggest Project',
          style: AppBarTheme.of(context)
              .textTheme
              .title
              .copyWith(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: kFabColor,
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              child: TextField(
                controller: _pnController,
                decoration: InputDecoration(
                    labelText: 'Project Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: TextField(
                controller: _nuController,
                decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            Container(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                  onPressed: () {
                    if (widget.project.id != null) {
                      db
                          .updateSuggest(Suggest(widget.project.id,
                              _pnController.text, _nuController.text))
                          .then((_) {
                        Navigator.pop(context);
                      });
                    } else {
                      db
                          .createSuggest(_pnController.text, _nuController.text)
                          .then((_) {
                        Navigator.pop(context);
                      });
                    }
                  },
                  color: Color(0xff183E8D),
                  child: (widget.project.id != null)
                      ? Text('UPDATE',
                          style: TextStyle(fontSize: 20.0, color: Colors.white))
                      : Text('SAVE',
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.white)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ))
          ],
        ),
      ),
    );
  }
}
