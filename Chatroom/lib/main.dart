import 'dart:async';

import 'package:chatroom/message_layout.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatroom App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Choosing User'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String data;
  @override
  void initState() {
    super.initState();

    DatabaseMethods.getMessages(DatabaseMethods.chatRoomID).then((data) {
      setState(() {
        this.data = data;
        const oneSecond = const Duration(seconds: 2);
        new Timer.periodic(oneSecond, (Timer t) => setState((){
          DatabaseMethods.getMessages(DatabaseMethods.chatRoomID);
        }));
      });
    });
  }
  
  String user1 = "empty";
  String user2 = "empty";

  void _user1(){
    setState(() {
    });
    user1 = "Main";
    user2 = "Secondary";
    if(DatabaseMethods.chatRoomID == "none"){
      _createChatRoom();
    }
    else{
      DatabaseMethods.getMessages(DatabaseMethods.chatRoomID);
      {Navigator.push(context, MaterialPageRoute(builder: (context) => _ChatPage("user1")));}
    }

  }

  void _user2(){
    setState(() {
    });
    user1 = "Secondary";
    user2 = "Main";
    DatabaseMethods.getMessages(DatabaseMethods.chatRoomID);
    if(DatabaseMethods.chatRoomID == "none"){
      _createChatRoom();
    }
    else{
      {Navigator.push(context, MaterialPageRoute(builder: (context) => _ChatPage("user2")));}
    }
  }

  _createChatRoom(){
//    setState(() {
//    });
    String main;
    String secondary;
    if(user1 == "Main"){
      main = "user1";
      secondary = "user2";
    }
    else{
      main = "user2";
      secondary = "user1";
    }
    Message startMessage1 = Message(
        messageUserID: secondary,
        text: "This is the messaging section.",
        time: DateTime.now().millisecondsSinceEpoch);
    Message startMessage2 = Message(
        messageUserID: secondary,
        text: "You can message your teammate through this.",
        time: DateTime.now().millisecondsSinceEpoch);
    String chatRoomID = "game1";
    DatabaseMethods.numMessages = 0;
    DatabaseMethods.chatRoomID = chatRoomID;
    Map<String, dynamic> startMessage1Map ={
      "messageUserID" : startMessage1.messageUserID,
      "text" : startMessage1.text,
      "time" : startMessage1.time,
    };
    Map<String, dynamic> startMessage2Map ={
      "messageUserID" : startMessage2.messageUserID,
      "text" : startMessage2.text,
      "time" : startMessage2.time,
    };
    Map<String, dynamic> chatRoomMap = {
      "main" : main,
      "secondary" : secondary,
      "game" : DatabaseMethods.chatRoomID,
    };
    List<Message> starters = [startMessage1, startMessage2];
    DatabaseMethods.createChatRoomWithVar(chatRoomID, chatRoomMap, starters);
    {Navigator.push(context, MaterialPageRoute(builder: (context) => _ChatPage(main)));}
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.


    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Choose whether you are User 1 or User 2',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.5,
                  ),
                  Text(
                    'User 1: $user1    User 2: $user2',
                    textScaleFactor: 1.25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("User 1"),
                        color:  Colors.blueAccent[600],
                        onPressed: _user1,
                      ),

                      RaisedButton(
                        child: Text("User 2"),
                        color:  Colors.blueAccent[600],
                        onPressed: _user2,
                      ),
                    ],
                  ),
                  RaisedButton(
                    child: Text("Create New Chat"),
                    color: Colors.blueAccent[600],
                    onPressed: () => _createChatRoom()
                  )
                ],
              ),
            )
          ),
        ],
        ),
    );
  }
}

class _ChatPage extends StatefulWidget{
  _ChatPage(String mainUserID, {Key key}) : super(key: key){
    this.mainUserID = mainUserID;
  }
  String mainUserID;

  @override
  ChatPage createState() => ChatPage(mainUserID);
}

class ChatPage extends State<_ChatPage>{
  ChatPage(this.mainUserID);

  _buildMessage(String text, int time, bool isMain){
    return Container(
      margin: isMain
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: isMain?
        BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15)
          )
        )
        :
        BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15)
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8,),
            Text(
              DateTime.fromMillisecondsSinceEpoch(time).toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 8.0,
                  fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
    );
  }

  String mainUserID;
  List<Message> messagesrev = [
//    Message(
//        messageUserID: "user1",
//        text: "Hello from User 1",
//        time: 1590942379777),
//    Message(
//        messageUserID: "user2",
//        text: "Hello back from User 2",
//        time: 1590942390000),
  ];

  List<Message> get messages => messagesrev.reversed.toList();
  TextEditingController messageComposer = new TextEditingController();
  Stream messagesStream;

  @override
  void initState(){
    super.initState();
    DatabaseMethods.getMessages(DatabaseMethods.chatRoomID).then((value){
      setState(() {
        messagesStream = value;
      });
    });
  }

  _sendMessage(){
    if(messageComposer.text.isNotEmpty){
      DatabaseMethods.sendMessage(DatabaseMethods.chatRoomID, new Message(messageUserID: mainUserID, text: messageComposer.text, time: DateTime.now().millisecondsSinceEpoch));
      messageComposer.text = "";
    }
  }

//  Widget messageList(){
//    return StreamBuilder(
//      stream: messagesStream,
//      builder: (context, snapshot){
//        return ListView.builder(
//          itemCount: ,
//        )
//      },
//    )
//  }

  _buildMessageComposer(){
    String message;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25,
            color: Colors.blue
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: messageComposer,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Colors.blue,
            onPressed: () => _sendMessage(),
          )
        ],
      )
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text("Chat",textAlign: TextAlign.center,),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30,
            color: Colors.white,
            onPressed: () {},
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)
                  ),
                  child: StreamBuilder(
                      stream: messagesStream,
                      builder: (context, snapshot){
                        return ListView.builder(
                            reverse: true,
                            padding: EdgeInsets.only(top: 20),
                            itemCount: snapshot.data != null ? snapshot.data.documents.length : 0,
                            itemBuilder: (BuildContext context, int index){
                              if(!snapshot.hasData){
                                print("No data in this");
                              }
                              print("Got here");
                              int len = snapshot.data.documents.length - 1;
                              print(snapshot.data);
                              String messageUserID = snapshot.data.documents[len - index].data["messageUserID"];
                              String text = snapshot.data.documents[len - index].data["text"];
                              int time = snapshot.data.documents[len - index].data["time"];
                              bool isMain = messageUserID == mainUserID;
                              return _buildMessage(text, time, isMain);
                            }
                        );
                      }
                  )
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        )
      )
    );
  }
}
