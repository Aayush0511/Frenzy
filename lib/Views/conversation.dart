import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frenzy/Helper/helperfunctions.dart';
import 'package:frenzy/Services/database.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  String _myName;
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageController = TextEditingController();
  Stream chatMessageStream;

  @override
  void initState() {
    getUserInfo();
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  getUserInfo() async{
    _myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {});
  }

  // ignore: non_constant_identifier_names
  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return MessageTile(snapshot.data.docs[index].get("message"), snapshot.data.docs[index].get("sentBy") == _myName);
            },
          reverse: true,
        ) : Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  sendMessage() {
    setState(() {
      if(messageController.text.isNotEmpty) {
        Map<String, dynamic> messageMap = {
          "message" : messageController.text,
          "sentBy" : _myName,
          "time" : DateTime.now().microsecondsSinceEpoch
        };
        databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
        messageController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoomId.toString().replaceAll("_", "").replaceAll(_myName, ""))
      ),
      body: Column(
        children: [
          Divider(height: 2,),
          Flexible(
              child: ChatMessageList(),
          ),
          Divider(height: 2,),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                          hintText: 'Enter your message...',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                            fontSize: 18,
                          ),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.send_rounded, color: Colors.white70,),
                          onPressed: (){
                            sendMessage();
                          },
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {

  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: isSendByMe ? EdgeInsets.only(left: 60) : EdgeInsets.only(right: 60),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [
              const Color(0xff007EF4),
              const Color(0xff2A75BC)
            ] : [
              const Color(0x1AFFFFFF),
              const Color(0x1AFFFFFF)
            ]
          ),
          borderRadius: isSendByMe ? BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18)
          ) : BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18)
          )
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17
          ),
        ),
      ),
    );
  }
}
