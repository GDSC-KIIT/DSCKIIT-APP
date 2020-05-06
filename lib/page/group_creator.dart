import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsckiit_app/utils/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:random_string/random_string.dart';

class CreateGroup extends StatefulWidget {
  final String uid;
  CreateGroup({Key key,this.uid}) : super(key:key);
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File _image;
  TextEditingController groupName = new TextEditingController();
  TextEditingController descriptionText = new TextEditingController();
  ProgressDialog progressDialog;
  String path;
  final StorageReference storageRef = FirebaseStorage.instance.ref().child(randomAlphaNumeric(15));

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      var length = _image.path.split('/');
      path = _image.path.split('/')[length.length-1];
    });
  }

  void showSnackBar(String message){
    Toast.show("$message", _scaffoldKey.currentContext, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
  }

  _createGroup(BuildContext context) async {
    if(groupName.text.isNotEmpty && descriptionText.text.isNotEmpty && _image!=null){
      progressDialog = new ProgressDialog(context,type: ProgressDialogType.Normal,showLogs: true);
      progressDialog.update(message: 'Creating Group Please Wait...');
      progressDialog.show();
      final StorageUploadTask uploadTask = storageRef.putFile(_image);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());
      Firestore.instance.collection('groups').document()
          .setData({'name': groupName.text,'description': descriptionText.text,'image_url': url,
      'members': FieldValue.arrayUnion([widget.uid]),'created_time': new DateTime.now().millisecondsSinceEpoch });
      showSnackBar('Success');
      progressDialog.hide();
      Navigator.pop(_scaffoldKey.currentContext);
    }else {
      showSnackBar('Plese Fill all Fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          )
        ],
      ),
    );

    final pageTitle = Container(
      alignment: Alignment.centerLeft,
      child: Text(
        "Group Details",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 30.0,
        ),
      ),
    );

    final formFieldSpacing = SizedBox(
      height: 20.0,
    );

    final registerForm = Padding(
      padding: EdgeInsets.only(top: 25.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _buildFormField('Name', Icons.title,groupName),
            formFieldSpacing,
            _buildFormField('Description', Icons.description,descriptionText),
            formFieldSpacing,
          ],
        ),
      ),
    );

    final submitBtn = Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
        height: 60.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(color: Colors.white),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(7.0),
          color: primaryColor,
          elevation: 10.0,
          shadowColor: Colors.white70,
          child: MaterialButton(
            onPressed: () => _createGroup(context),
            child: Text(
              'Create Group',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    final uploadBtn = Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: Container(
        height: 60.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.white),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(7.0),
          color: primaryColor,
          elevation: 5.0,
          shadowColor: Colors.white70,
          child: MaterialButton(
            onPressed: ()  => getImage(),
            child: Text(
              'Upload Image',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 40.0),
          child: Column(
            children: <Widget>[
              appBar,
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    pageTitle,
                    registerForm,
                    uploadBtn,
                    Padding(padding: EdgeInsets.all(10),child: Center(child: Center(child:
                    new Text(
                        _image == null ? '' : path
                    ))),),
                    submitBtn
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String label, IconData icon,TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(
          icon,
          color: Colors.black38,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
    );
  }
}