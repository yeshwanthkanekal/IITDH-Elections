import 'package:flutter/material.dart';
import 'InputFields.dart';
import 'globals.dart' as globals;

class FormContainer extends StatelessWidget {

  @override
  FormContainer({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //final TextEditingController mycontroller3 = globals.myController1;
    //final TextEditingController mycontroller4 = globals.myController2;
    return (new Container(
      margin: new EdgeInsets.symmetric(horizontal: 20.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Form(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new InputFieldArea(
                    hint: "Username",
                    obscure: false,
                    icon: Icons.person_outline,
                  ),
                  new InputFieldArea(
                    hint: "Password",
                    obscure: true,
                    icon: Icons.lock_outline,
                  ),
                ],
              )),
        ],
      ),
    ));
  }
}
