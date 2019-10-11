import 'package:flutter/material.dart';
import 'dart:async';
import 'home.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:fluttertoast/fluttertoast.dart';

class StaggerAnimation extends StatefulWidget {
  final AnimationController buttonController;
  final Animation buttonSqueezeanimation;
  final Animation<EdgeInsets> containerCircleAnimation;

  @override
  StaggerAnimation({Key key, this.buttonController})
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
  StaggerAnimationState createState() => StaggerAnimationState();
}
class StaggerAnimationState extends State<StaggerAnimation> {
  int i = 0;

  Future<Null> _playAnimation() async {
    try {
      await widget.buttonController.forward();
      //await widget.buttonController.reverse();
    } on TickerCanceled {}
  }
  Future<Null> _showToast(String message) async {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
    );
  }
  Future<Null> _webfuture() async {
    Future<bool> _onWillPop(BuildContext context) {
      return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: new Text('Are you sure to Log out?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  timeDilation = 0.1;
                  Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> r) => false);},
                child: new Text('Yes'),
              ),
            ],
          );
        },

      ) ??
          false;
    }
    //print(myController.text);
    final response2 =
    await http.get(
        'http://10.196.6.112:8012/elections-iitdh/isattempted.php?username=${globals.myController1.text}&password=${globals.myController2.text}');
    final response =
    await http.get(
        'http://10.196.6.112:8012/elections-iitdh/login.php?username=${globals.myController1.text}&password=${globals.myController2.text}');
    if (response2.statusCode == 200 && response.statusCode == 200) {
      List<String> StrArray = response.body.toString().split(",");
      print(response.body.toString());
      print(StrArray);
      print("careeeeeeeeeeeeeeeeee"+response2.body.toString());
      if (response2.body.toString() == "1"){
        widget.buttonController.reverse();
        widget.buttonController.reset();
        setState(() {
          i = 0;
        });
        _showToast("Already attempted");

    }
    else{
        if (StrArray[0] == "1") {
          widget.buttonController.reverse();
          widget.buttonController.reset();
          setState(() {
            i = 0;
          });
          Navigator.push(context, MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return new WillPopScope(
                onWillPop: () => _onWillPop(context),
                child: Scaffold(
                  //appBar: AppBar(title: Text('My Page')),
                  body: CollapsingList(listarray: StrArray,),
                ),
              );
            },
          ));
          _showToast("Successfully Logged In");
        }
        else {
          widget.buttonController.reverse();
          widget.buttonController.reset();
          setState(() {
            i = 0;
          });
          _showToast("Invalid details");
        }
      }
    }
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
                  "Sign In",
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
    widget.buttonController.addListener((){
      if(widget.buttonController.isCompleted){
        //_loginButtonController.removeListener(this);
        if(i == 0){

          _webfuture();
          i++;
          print(i);
        }

      }
    });
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: widget.buttonController,
    );
  }

}
