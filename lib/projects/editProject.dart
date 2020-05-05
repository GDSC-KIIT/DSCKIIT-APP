import 'package:flutter/material.dart';

class EditProject extends StatefulWidget {
  final String id;
  EditProject(this.id);
  @override
  _EditProjectState createState() => _EditProjectState(id);
}

class _EditProjectState extends State<EditProject> {
  String id;
  _EditProjectState(this.id);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
