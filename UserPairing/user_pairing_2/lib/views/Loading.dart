import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_pairing_2/views/Waiting.dart';
import 'package:user_pairing_2/views/triviagame.dart';
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String data;

  @override
  void initState() {
    super.initState();

    loadData().then((data) {
      setState(() {
        this.data = data;
        const oneSecond = const Duration(seconds: 2);
        new Timer.periodic(oneSecond, (Timer t) => setState((){
          loadData();
        }));
      });
    });
  }

  Future loadData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var pendingGames = await Firestore.instance.collection("group")
        .where("creator", isEqualTo: user.displayName)
        .where("searching", isEqualTo: true)
        .getDocuments();
    var len = pendingGames.documents.length;


      if (len == 0) {
        this.data = len.toString();
      } else {
        this.data = null;
      }


  }

  @override
  Widget build(BuildContext context) {
    return data != null ? TriviaGame() : Waiting();
  }
}
