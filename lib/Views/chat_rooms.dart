import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frenzy/Helper/authenticate.dart';
import 'package:frenzy/Helper/helperfunctions.dart';
import 'package:frenzy/Services/auth.dart';
import 'package:frenzy/Services/database.dart';
import 'package:frenzy/Views/conversation.dart';
import 'package:frenzy/Views/search.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  String _myName2;
  Stream chatRoomStream;
  
  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ChatRoomsTile(
                snapshot.data.docs[index].get("chatroomid").toString().replaceAll("_", "").replaceAll(_myName2, ""),
                  snapshot.data.docs[index].get("chatroomid")
              );
            }
        ) : Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    _myName2 = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(_myName2).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/frenzy_logo.png', height: 38),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () => {
                  authMethods.signOut(),
                  HelperFunctions.saveUserLoggedInSharedPreference(false),
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()))
                },
            ),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {

  final String userName;
  final String chatRoomId;
  ChatRoomsTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Center(
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                    "${userName.substring(0, 1).toUpperCase()}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
              ),
            ),
            SizedBox(width: 16,),
            Text(
              userName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18
              ),
            ),
          ],
        ),
      ),
    );
  }
}
