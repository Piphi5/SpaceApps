import 'package:flutter/material.dart';
import 'package:user_pairing_2/widgets/widget.dart';

class Waiting extends StatefulWidget {
  @override
  _WaitingState createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        
          appBar: appBarMain(context),
          backgroundColor: Colors.transparent,
      body: Container(
          child: Text("Waiting...", style: TextStyle(color: Colors.black87))
      ),
    );
  }

}