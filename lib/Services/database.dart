import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  getUserByUsername(String username) async{
    return await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: username).get();
  }

  getUserByUserEmail(String userEmail) async{
    return await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: userEmail).get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection('users').add(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance.collection('ChatRoom').doc(chatRoomId).set(chatRoomMap);
  }

  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection('chats').add(messageMap);
  }

  getConversationMessages(String chatRoomId) async{
    return FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection('chats').orderBy("time", descending: true).snapshots();
  }

  getChatRooms(String userName) async{
    return FirebaseFirestore.instance.collection("ChatRoom").where("users", arrayContains: userName).snapshots();
  }
}