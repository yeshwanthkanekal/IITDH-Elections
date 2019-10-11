import 'package:flutter/material.dart';
import 'SignUpRollNo.dart';

class SignUp extends StatelessWidget {
  SignUp();
  @override
  Widget build(BuildContext context) {
    return (new FlatButton(

      padding: const EdgeInsets.only(
        top: 160.0,
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return new WillPopScope(
              //onWillPop: () => _onWillPop(context),
              child: Scaffold(
                //appBar: AppBar(title: Text('My Page')),
                body: SignUpRollNo(),
              ),
            );
          },
        ));
      },
      child: new Text(
        "Generate/Change Password",
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: new TextStyle(
            fontWeight: FontWeight.w300,
            letterSpacing: 0.5,
            color: Colors.white,
            fontSize: 12.0),
      ),
    ));
  }
}
