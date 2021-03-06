import 'package:flutter/material.dart';
import 'package:user_pairing_2/views/signin.dart';
import 'package:user_pairing_2/views/signup.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SignIn(toggleView);
    } else {
      return SignUp(toggleView);
    }
  }
}