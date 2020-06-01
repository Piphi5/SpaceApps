import 'package:cloud_firestore/cloud_firestore.dart';
import 'message_layout.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

class DatabaseMethods{
  static String chatRoomID = "none";
  static int numMessages = 0;
  static createChatRoomWithVar(String chatRoomID, chatRoomMap, List<Message> starters){
    Firestore.instance.collection("chatrooms")
        .document(chatRoomID).setData(chatRoomMap);
    DatabaseMethods.chatRoomID = chatRoomID;
//    sendMessage(chatRoomID, starters[0]);
//    sendMessage(chatRoomID, starters[1]);
  }

  static sendMessage(String chatRoomID, Message message){
    String messageid = numMessages.toString();
    numMessages++;
    Map<String, dynamic> messageMap = {
      "messageUserID" : message.messageUserID,
      "text" : message.text,
      "time" : message.time
    };
    Firestore.instance.collection("chatrooms/" + chatRoomID + "/messages")
        .document(messageid).setData(messageMap);
  }

  static Future getMessages(String chatRoomID)async{
    print("RanGetMessages");
    return await Firestore.instance.collection("chatrooms")
        .document(chatRoomID)
        .collection("messages")
        .snapshots();
  }
}