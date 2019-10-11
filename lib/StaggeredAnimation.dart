import 'package:flutter/material.dart';
import 'dart:async';
import 'home.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:fluttertoast/fluttertoast.dart';

class StaggeredAnimation extends StatefulWidget {
  final AnimationController buttonController;
  final Animation buttonSqueezeanimation;
  final Animation<EdgeInsets> containerCircleAnimation;

  @override
  StaggeredAnimation({Key key, this.buttonController})
      : buttonSqueezeanimation = new Tween(
    begin: 320.0,
    end: 70.0,
  )
      .animate(
    new CurvedAnimation(
      parent: buttonController,
      curve: new Interval(
        0.0,
        0.125,
      ),
    ),
  ),
        containerCircleAnimation = new EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 50.0),
          end: const EdgeInsets.only(bottom: 0.0),
        )
            .animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.500,
              0.800,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);
  StaggeredAnimationState createState() => StaggeredAnimationState();


}
@override
class StaggeredAnimationState extends State<StaggeredAnimation> {
  Future<Null> _playAnimation() async {
    try {
      await widget.buttonController.forward();
      //await widget.buttonController.reverse();
    } on TickerCanceled {}
  }
  Widget _buildAnimation(BuildContext context, Widget child) {
    return new Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: new InkWell(
          onTap: () {
            //_getfutureweb();
            _playAnimation();
          },
          child: new Hero(
            tag: "fade",
            child: new Container(
                width: widget.buttonSqueezeanimation.value,
                height: 60.0,
                alignment: FractionalOffset.center,
                decoration: new BoxDecoration(
                  color: const Color.fromRGBO(247, 64, 106, 1.0),
                  borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
                ),
                child: widget.buttonSqueezeanimation.value > 75.0
                    ? new Text(
                  "Submit",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.3,
                  ),
                )
                    : new CircularProgressIndicator(
                  value: null,
                  strokeWidth: 1.0,
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      Colors.white),
                )),
          )),
    );
  }
  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: widget.buttonController,
    );
  }

}