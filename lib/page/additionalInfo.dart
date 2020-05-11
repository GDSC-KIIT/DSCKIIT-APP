import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsckiit_app/Widgets/rounded_button.dart';
import 'package:dsckiit_app/page/animationLoader.dart';
import 'package:dsckiit_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdditionalInfoScreen extends StatefulWidget {
  AdditionalInfoScreen({this.number = 0});
  int number;
  @override
  State<StatefulWidget> createState() => new _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState extends State<AdditionalInfoScreen> {
  TextEditingController _numController;
  Map<String, String> domains = Map();
  String _number;
  List<MultiSelectDialogItem<String>> multiItem = List();
  Set<String> _selectedDomains = {};

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  List<String> domainsFinal = [];

  FirebaseUser user;
  bool isSignedIn = false;

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

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);
    return ref.updateData({
      'domains': FieldValue.arrayUnion(_selectedDomains.toList()),
      'contactNumber': _number,
    });
  }

  void showUserData(FirebaseUser user) async{
    await _db.collection('users').document(user.uid).get().then((DocumentSnapshot)=>{
      print(DocumentSnapshot.data)
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuthentication();
    getUser();
    populateDomain();
  }

  void populateDomain() async {
    await _db.collection('domains').document('listOfDomains').get().then((DocumentSnapshot)=>{
      DocumentSnapshot.data.forEach((k, v){
        domains[k] = v;
      })
    });
  }

  void populateMultiSelect() {
    for (String domainId in domains.keys) {
      multiItem.add(MultiSelectDialogItem(domainId, domains[domainId]));
    }
  }

  void _showMultiSelect(BuildContext context) async {
    multiItem = [];
    await populateMultiSelect();
    final items = multiItem;
    _selectedDomains = await showDialog<Set<String>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
        );
      },
    );
    print(_selectedDomains);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.number==0?false:true,
        title: Text('Additional Info'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 15, right: 15, bottom: 15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Domain: ", style: TextStyle(fontSize: 20),),
                  SizedBox(width: 10,),
                  RoundedButton(
                    text: 'Choose Domain',
                    textColor: Colors.white,
                    color: primaryColor,
                    onPressed: () => _showMultiSelect(context),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  controller: _numController,
                  onChanged: (text){
                    setState(() {
                      _number = text;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'Whatsapp Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(padding: new EdgeInsets.all(5.0)),
              Text("Your number is useful to add you to a whatsapp group in case of your participation in a project"),
              Padding(padding: new EdgeInsets.all(5.0)),
              Container(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                  onPressed: () {
                    if(_selectedDomains.isNotEmpty){
//                      _number = _numController.text;
                      updateUserData(user);
                      showUserData(user);
                      Navigator.pop(context);
                    }
                  },
                  color: Color(0xFF183E8D),
                  child: Text('Confirm',
                      style: TextStyle(fontSize: 20.0, color: Colors.white)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues})
      : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Domain'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}
