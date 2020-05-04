import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class AnimationLoader extends StatefulWidget {
  @override
  _AnimationLoaderState createState() => _AnimationLoaderState();
}

class _AnimationLoaderState extends State<AnimationLoader> {

  var googleColors =[
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.white
  ];

  colorChange(int x) async {
    for (var i = 0; i < 5;) {
      if(i != 5){
        i++;
      }
      else{
        i=0;
        continue;
      }
      return i;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SpinKitWave(
        type: SpinKitWaveType.center,
        itemBuilder: (BuildContext context,int index){
          return DecoratedBox(
            decoration: BoxDecoration(
              color: googleColors[colorChange(0)],
            ),
          );
        },
      ),
    );
  }
}
