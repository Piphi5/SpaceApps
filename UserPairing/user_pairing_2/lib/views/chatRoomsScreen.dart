import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_pairing_2/views/Authenticate.dart';
import 'package:user_pairing_2/views/Loading.dart';
import 'package:user_pairing_2/views/auth.dart';
import 'package:user_pairing_2/views/databasemethods.dart';
import 'package:user_pairing_2/views/signin.dart';
import 'package:user_pairing_2/views/triviagame.dart';
import 'package:user_pairing_2/widgets/widget.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods dbMethods = new DatabaseMethods();

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('games').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.where((data) => data["searching"]).toList().map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final game = Game.fromSnapshot(data);
    return Padding(
      key: ValueKey(game.gameName),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(game.gameName, style: TextStyle(color: Colors.white)),
          trailing: Text(game.isSearching.toString() , style: TextStyle(color: Colors.white)),
          onTap: () {
            dbMethods.joinGame(game.reference.documentID);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => TriviaGame()));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Image.asset(
            "assets/images/cogologo.png",
            height: 50,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                authMethods.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.exit_to_app)),
            ),
          ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(height: 200, child: _buildBody(context)),
          SizedBox(
            height: 250,
          ),
          GestureDetector(
            onTap: () async {
              DocumentReference ref = await dbMethods.createGame();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [const Color(0xff007EF4), const Color(0xff2A75BC)],
                  )),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Create Game",
                style: mediumTextFieldStyle(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}


