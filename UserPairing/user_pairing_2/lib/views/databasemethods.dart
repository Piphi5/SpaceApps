import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  final databaseReference = Firestore.instance;
  getUserbyUsername(String username) {
    Firestore.instance.collection("users")
        .where("displayName", isEqualTo: username)
        .getDocuments();
  }

  createGame() async {
    Game createdGame;
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentReference ref = await databaseReference.collection("games")
    .add({
      'creator' : {'uid' : user.uid},
      'joiner' : null,
      'searching' : true,
    });





  }

  joinGame(String key) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final dataRef = databaseReference.collection("games").document(key);


    dataRef.updateData({
      'joiner' : {'uid' : user.uid},
      'searching' : false
    });

  }

  updateMatchStatus(String uid, int value) async {
    // 0 - Not looking, 1 - Searching, 2- found someone
    Firestore.instance.collection("users").document(uid).updateData({"matchStatus" : value});
  }


  uploadUserInfo(userMap){
    Firestore.instance.collection("users")
        .add(userMap);
  }
  getUserInfo(String email) async {
    return Firestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

}

class Game {
  final String gameName;
  final bool isSearching;
  final DocumentReference reference;

  Game.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['searching'] != null),
        gameName = reference.documentID,
        isSearching = map['searching'];

  Game.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}