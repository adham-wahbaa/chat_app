import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/view_model/app_brain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService {
  static void fetchUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection("users").get();
    final users = snapshot.docs
        .where(
          (document) =>
              FirebaseAuth.instance.currentUser!.uid != document.data()["id"] &&
              document.data()["isVerified"] == true,
        )
        .map((document) => UserModel.fromMap(document.data()))
        .toList();

    appBrain.users.value = users;
  }

  static String createChatId(String receiverId) {
    String chatId;
    String myId = FirebaseAuth.instance.currentUser!.uid;
    if (myId.compareTo(receiverId) < 0) {
      chatId = "$myId$receiverId";
    } else {
      chatId = "$receiverId$myId";
    }
    return chatId;
  }

  static Future<bool> checkIfChatExists(String chatId) async {
    final document = await FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .get();
    return document.exists;
  }

  static Future<void> createChat(String chatId) async {
    await FirebaseFirestore.instance.collection('chats').doc(chatId).set({});
  }

  static Future<void> sendMessage(MessageModel message, String chatId) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(message.id).set(message.toJson());
  }

  static Stream<List<MessageModel>> getMessages(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timeStamp')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromJson(doc.data());
      }).toList();
    });
  }
  static Future<void> deletemessage(String chatId, String id,context) async {
    try{
    print("deleting message with id: $id from chat: $chatId");
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(id)
          .delete();
    }on FirebaseException
      catch (e) {
     print("Failed to delete message: $e");
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Message deleted")),);
  }
}
