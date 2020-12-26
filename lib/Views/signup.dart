import 'package:flutter/material.dart';
import 'package:frenzy/Helper/helperfunctions.dart';
import 'package:frenzy/Services/auth.dart';
import 'package:frenzy/Services/database.dart';
import 'package:frenzy/Views/chat_rooms.dart';
import 'package:frenzy/Widgets/widget.dart';

class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;
  AuthMethods authMethods = AuthMethods();
  final formKey = GlobalKey<FormState>();

  DatabaseMethods databaseMethods = DatabaseMethods();

  TextEditingController userName = new TextEditingController();
  TextEditingController eMail = new TextEditingController();
  TextEditingController passWord = new TextEditingController();

  signMeUp() {
    if(formKey.currentState.validate()) {

      Map<String, String> userInfoMap = {
        'username' : userName.text,
        'email' : eMail.text
      };

      HelperFunctions.saveUserNameSharedPreference(userName.text);
      HelperFunctions.saveUserEmailSharedPreference(eMail.text);

      setState(() {
        isLoading = true;
      });

      authMethods.signUpWithEmailAndPassword(eMail.text, passWord.text).then((value) => {
        databaseMethods.uploadUserInfo(userInfoMap),
      HelperFunctions.saveUserLoggedInSharedPreference(true),
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()))
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
                          return val.isEmpty || val.length < 3? 'Enter a valid username' : null;
                        },
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration('Username'),
                        controller: userName,
                      ),
                      TextFormField(
                        validator: (val) {
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : 'Provide a valid e-mail ID';
                        },
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration('E-mail'),
                        controller: eMail,
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val) {
                          return val.isEmpty || val.length < 6? 'Enter a strong valid password' : null;
                        },
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration('Password'),
                        controller: passWord,
                      ),
                    ],
                  )
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
                  signMeUp();
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
                    'Sign Up',
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
                  'Sign Up with Google',
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
                    "Already have an account? ",
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
                        "Log In",
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
