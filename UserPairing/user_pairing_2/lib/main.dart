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
      title: 'FlutterChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        accentColor: Colors.white,
        fontFamily: "OverpassRegular",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Authenticate(),
    );
  }
}


