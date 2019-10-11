import 'package:flutter/material.dart';

class Tick extends StatelessWidget {
  final DecorationImage image;
  Tick({this.image});
  @override
  Widget build(BuildContext context) {
    return (new Container(
      width: 250.0,
      height: 250.0,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        image: new DecorationImage(image: new NetworkImage("http://10.250.1.243/IIT-Dharwad-Logo.png")),
      ),
    ));
  }
}
