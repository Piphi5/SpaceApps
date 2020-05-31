import 'package:flutter/material.dart';
import 'package:user_pairing_2/views/auth.dart';
import 'package:user_pairing_2/widgets/widget.dart';
import 'chatRoomsScreen.dart';
import 'databasemethods.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  
  signMeUp() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods.signUpwithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val) {
        print("$val");

        Map<String, dynamic> userInfoMap = {
          "displayName" : userNameTextEditingController.text,
          "email" : emailTextEditingController.text,
          "points" : 0,
          "matchStatus" : 0

        };

        databaseMethods.uploadUserInfo(userInfoMap);
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => ChatRoom()
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container (
        child: Center(child: CircularProgressIndicator()
      )) : SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height - 50,
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) {
                            return val.isEmpty || val.length < 4 ? "Please enter valid username" : null;
                          },
                          controller: userNameTextEditingController,
                          style: simpleTextFieldStyle() ,
                          decoration: textFieldInputDecoration("username"),
                        ),
                        TextFormField(
                          validator: (val) {
                            return val.isEmpty || val.length < 4 ? "Please enter an email" : null;
                          },
                          controller: emailTextEditingController,
                          style: simpleTextFieldStyle() ,
                          decoration: textFieldInputDecoration("email"),
                        ),
                        TextFormField(
                            validator: (val) {
                              return val.isEmpty || val.length < 6 ? "Please provide a 6+ character password" : null;
                            },
                            controller: passwordTextEditingController,
                            style: simpleTextFieldStyle(),
                            decoration: textFieldInputDecoration("password")
                        ),
                      ],

                    ),
                  ),


                  SizedBox(height: 8),
                  Container(
                        alignment: Alignment.centerRight,
                        child:Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text("Forgot Password?", style: simpleTextFieldStyle()),
                        ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: (){
                      signMeUp();
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0xff007EF4),
                                  const Color(0xff2A75BC)
                                ]
                            ),
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Text("Sign Up", style: simpleTextFieldStyle(), )
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Text("Sign Up with Google", style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17
                      ), )
                  ),
                  SizedBox(height: 16,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?", style: mediumTextFieldStyle()),
                        GestureDetector(
                          onTap: () {
                            widget.toggle();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text("Signin now", style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                decoration: TextDecoration.underline
                            ),),
                          ),
                        )
                      ]
                  ),
                  SizedBox(height: 16),
                ],
              )
          )


      ),

    );
  }
}