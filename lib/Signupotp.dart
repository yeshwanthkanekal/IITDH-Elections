import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'styles.dart';
import 'WhiteTick.dart';
import 'StaggeredAnimation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpotp extends StatefulWidget {
  final String myUsername;
  const SignUpotp({Key key, this.myUsername}) : super(key: key);
  //final String title;
  @override
  SignUpotpState createState() => new SignUpotpState();
}

class SignUpotpState extends State<SignUpotp> with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  var animationStatus = 0;
  final myController = TextEditingController();
  final myController1 = TextEditingController();
  int i = 0;
  @override
  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      //await _loginButtonController.reverse();
    } on TickerCanceled {}
  }
  Future<Null> _showToast(String messag) async {
    Fluttertoast.showToast(
      msg: messag,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
    );
  }
  Future<Null> _webfuture() async {
    print("Finally yeshqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
    print("start");
    print(widget.myUsername);
    //print(myController1.text);
    //print(myController.text);
    final response =
    await http.get(
        'http://10.196.6.112:8012/elections-iitdh/userRegistration.php?username=${widget.myUsername}&password=${myController1.text}&otp=${myController.text}');
    if (response.statusCode == 200) {
      if(response.body.toString() == "11"){
        _loginButtonController.reverse();
        _loginButtonController.reset();
        setState(() {
          i = 0;
        });
        _showToast("Successfully updated password");
      }
      else{
        _loginButtonController.reverse();
        _loginButtonController.reset();
        setState(() {
          i = 0;
        });
        _showToast("Invalid details");
      }
    }
  }
  @override
  Widget build(BuildContext context) {

    _loginButtonController.addListener((){
      if(_loginButtonController.isCompleted){
        //_loginButtonController.removeListener(this);
        if(i == 0){

          _webfuture();
          i++;
          print(i);
        }

      }
    });
    return (new Container(
        decoration: new BoxDecoration(
          image: backgroundImage,
        ),
        child: new Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: <Color>[
                    const Color.fromRGBO(162, 146, 199, 0.8),
                    const Color.fromRGBO(51, 51, 63, 0.9),
                  ],
                  stops: [0.2, 1.0],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.0, 1.0),
                )),
            child: new ListView(
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                new Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Tick(image: tick),
                        new Container(
                          margin: new EdgeInsets.symmetric(horizontal: 20.0),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Form(
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      new Container(
                                        decoration: new BoxDecoration(
                                          border: new Border(
                                            bottom: new BorderSide(
                                              width: 0.5,
                                              color: Colors.white24,
                                            ),
                                          ),
                                        ),
                                        child: new TextFormField(
                                          obscureText: true,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          controller: myController,
                                          decoration: new InputDecoration(
                                            icon: new Icon(
                                              Icons.lock_outline,
                                              color: Colors.white,
                                            ),
                                            border: InputBorder.none,
                                            hintText: "Enter Otp",
                                            hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
                                            contentPadding: const EdgeInsets.only(
                                                top: 30.0, right: 30.0, bottom: 30.0, left: 5.0),
                                          ),
                                        ),
                                      ),
                                      new Container(
                                        decoration: new BoxDecoration(
                                          border: new Border(
                                            bottom: new BorderSide(
                                              width: 0.5,
                                              color: Colors.white24,
                                            ),
                                          ),
                                        ),
                                        child: new TextFormField(
                                          obscureText: true,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          controller: myController1,
                                          decoration: new InputDecoration(
                                            icon: new Icon(
                                              Icons.lock_outline,
                                              color: Colors.white,
                                            ),
                                            border: InputBorder.none,
                                            hintText: "New Password",
                                            hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
                                            contentPadding: const EdgeInsets.only(
                                                top: 30.0, right: 30.0, bottom: 30.0, left: 5.0),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        animationStatus == 0
                            ? new InkWell(
                            onTap: () {
                              setState(() {
                                animationStatus = 1;
                              });
                              _playAnimation();
                              //_webfuture();
                            },
                            child: new Container(
                              width: 320.0,
                              height: 60.0,
                              alignment: FractionalOffset.center,
                              decoration: new BoxDecoration(
                                color: const Color.fromRGBO(247, 64, 106, 1.0),
                                borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
                              ),
                              child: new Text(
                                "Submit",
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            )) :
                        new StaggeredAnimation(
                            buttonController:
                            _loginButtonController.view),
                        //new SignUp()
                      ],
                    ),

                  ],
                ),
              ],
            ))));

  }

}
