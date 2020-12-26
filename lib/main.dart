import 'package:flutter/material.dart';
import 'package:frenzy/Helper/authenticate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frenzy/Helper/helperfunctions.dart';
import 'package:frenzy/Views/chat_rooms.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      if(value == null) {
        HelperFunctions.saveUserLoggedInSharedPreference(false);
      } else {
        setState(() {
          userIsLoggedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff2A75BC),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn? ChatRoom() : Authenticate(),
    );
  }
}
