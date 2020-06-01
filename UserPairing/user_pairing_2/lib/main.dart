import 'package:flutter/material.dart';
import 'package:user_pairing_2/views/Authenticate.dart';
import 'package:user_pairing_2/views/signup.dart';
import 'package:user_pairing_2/views/triviagame.dart';

import 'views/signin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: TriviaGame(),
    );
  }
}


