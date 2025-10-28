import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {

  final String id;
  final String message;
  final String senderId;
  final String senderName;
  final DateTime timeStamp;

  MessageModel({
    required this.id,
    required this.message,
    required this.senderId,
    required this.senderName,
    required this.timeStamp,
  });

  factory MessageModel.fromJson(Map<String,dynamic> json){
    return MessageModel(
        id: json["id"],
        message: json["message"],
        senderId: json["senderId"],
        senderName: json["senderName"],
        timeStamp: (json["timeStamp"] as Timestamp).toDate()
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "message": message,
      "senderId": senderId,
      "senderName": senderName,
      "timeStamp": timeStamp
    };
  }



}