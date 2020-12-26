import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frenzy/Helper/helperfunctions.dart';
import 'package:frenzy/Services/auth.dart';
import 'package:frenzy/Services/database.dart';
import 'package:frenzy/Views/chat_rooms.dart';
import 'package:frenzy/Widgets/widget.dart';

class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController eMail = TextEditingController();
  TextEditingController passWord = TextEditingController();
  bool isLoading = false;
  QuerySnapshot snapShotUserInfo;

  signMeIn() {
    if(formKey.currentState.validate()) {

      HelperFunctions.saveUserEmailSharedPreference(eMail.text);

      databaseMethods.getUserByUserEmail(eMail.text).then((val) {
        snapShotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(snapShotUserInfo.docs[0].get('username'));
        HelperFunctions.saveUserEmailSharedPreference(snapShotUserInfo.docs[0].get('email'));
      });

      setState(() {
        isLoading = true;
      });

      authMethods.signInWithEmailAndPassword(eMail.text, passWord.text).then((value) => {
        if(value != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true),
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()))
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) : SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 200,
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
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : 'Provide a valid e-mail ID';
                      },
                      controller: eMail,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration('E-mail'),
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (val) {
                        return val.isEmpty || val.length < 6? 'Enter a strong valid password' : null;
                      },
                      controller: passWord,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration('Password'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8,),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Forgot password?', style: simpleTextStyle(),),
                ),
              ),
              SizedBox(height: 16,),
              GestureDetector(
                onTap: () {
                  signMeIn();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xff007Ef4),
                        const Color(0xff2A75BC)
                      ]
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12,),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Sign In with Google',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      widget.toggle();
                    },
                    child: Container(
                      child: Text(
                        "Register now",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
