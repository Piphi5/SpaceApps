import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COGO Trivia Demo',
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
      home: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new NetworkImage("https://apod.nasa.gov/apod/image/1708/NGC2442-HST-ESO-L.jpg"), fit: BoxFit.cover),
          ),
         child: MyHomePage(title: 'COGO Trivia Demo')
      ),
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
  Future<Question> currQuestion;

  Future<void> main() async {
    var url = "https://question-generator543211.herokuapp.com/api/question";
    final httpClient = HttpClient();
    final request = await httpClient.getUrl(Uri.parse(url));
    final response = await request.close();
    return response;
  }

  Future<Question> getQuestion() async {
    main();
    var url = "https://question-generator543211.herokuapp.com/api/question";
    var response = await http.Client()
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print(response);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Question.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    currQuestion = getQuestion();
    int answerIndex = 0;
  }

  showAlertDialog(BuildContext context, String text) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Result"),
      content: Text(text),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.transparent,
      body: Center(
          child: FutureBuilder<Question>(
              future: currQuestion,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                          height: 200,
                          width: 300,
                          child: Image.network(snapshot.data.imgUrl)),
                      SizedBox(
                        height: 16,
                      ),
                      Text(snapshot.data.question,
                      style: TextStyle(color: Colors.white, fontSize: 16),),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 300,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data.answerChoices.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  showAlertDialog(
                                      context,
                                      snapshot.data.answerChoices[index] ==
                                              snapshot.data.answer
                                          ? "That's correct!"
                                          : "That's incorrect!");
                                  currQuestion = getQuestion();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18.0),
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    )),
                                height: 50,
                                child: Center(
                                  child: Text(
                                      snapshot.data.answerChoices[index],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              })), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Question {
  final String question;
  final String answer;
  final String imgUrl;
  final List answerChoices;

  Question({this.question, this.answer, this.imgUrl, this.answerChoices});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        question: json['question'],
        answer: json['answer'],
        imgUrl: json['image'],
        answerChoices: json['choices'].toList());
  }
}
