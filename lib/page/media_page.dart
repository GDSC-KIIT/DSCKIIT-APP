import 'package:flutter/material.dart';

//TODO: Modify card.
class MediaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Media"),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent[200],
      ),
      body: Container(
          child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 20,
        itemBuilder: (context, int index) {
          return Card(
            child: Image(
              height: 70,
              width: MediaQuery.of(context).size.width,
              image: NetworkImage(
                  "https://cdn0.iconfinder.com/data/icons/electronics-60/48/99-512.png"),
            ),
          );
        },
      )),
    );
  }
}
