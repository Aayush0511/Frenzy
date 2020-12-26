import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frenzy/Helper/helperfunctions.dart';
import 'package:frenzy/Services/database.dart';
import 'package:frenzy/Views/conversation.dart';
import 'package:frenzy/Widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchUser = TextEditingController();
  String _myName1;
  DatabaseMethods databaseMethods = DatabaseMethods();

  QuerySnapshot searchSnapshot;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    _myName1 = await HelperFunctions.getUserNameSharedPreference();
    setState(() {});
  }

  initiateSearch() {
    databaseMethods.getUserByUsername(searchUser.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createAndStartConversation(String userName) {

    if(userName != _myName1) {
      String chatRoomId = getChatRoomId(userName, _myName1);

      List<String> users = [userName, _myName1];

      Map<String, dynamic> chatRoomMap = {
        'users' : users,
        'chatroomid' : chatRoomId
      };

      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId)));
    } else {
      print("Cannot send self message");
    }
  }

  Widget searchList() {
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return SearchTile(
            userName: searchSnapshot.docs[index].get('username'),
            userEmail: searchSnapshot.docs[index].get('email'),
          );
        }
        ) : Container();
  }

  // ignore: non_constant_identifier_names
  Widget SearchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                ),
              ),
              SizedBox(height: 4,),
              Text(
                userEmail,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createAndStartConversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Text('Message', style: TextStyle(color: Colors.white, fontSize: 15),),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchUser,
                        style: TextStyle(
                            color: Colors.white,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search user',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                            fontSize: 18,
                          ),
                          border: InputBorder.none
                        ),
                      ),
                    ),
                    Container(
                      height: 45,
                        width: 45,
                        child: Center(
                          child: IconButton(
                              icon: Icon(Icons.search_rounded, color: Colors.white70,),
                              onPressed: (){
                                initiateSearch();
                              },
                          ),
                        )
                    )
                  ],
                ),
              ),
              searchList(),
            ],
          ),
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}