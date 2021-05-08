import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  List<ChatMessage> messages;

  ChatModel({this.messages});

  ChatModel.fromJson(List<DocumentSnapshot> json) {
    messages = List<ChatMessage>();
    json.forEach((v) {
      Map<String, dynamic> _data = v.data();
      messages.add(ChatMessage.fromJson(_data));
    });
  }
}

class ChatMessage {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  String type;

  ChatMessage({
    this.idFrom,
    this.idTo,
    this.timestamp,
    this.content,
    this.type,
  });

  ChatMessage.fromJson(Map<String, dynamic> json) {
    idFrom = json['idFrom'];
    idTo = json['idTo'];
    timestamp = json['timestamp'];
    content = json['content'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idFrom'] = this.idFrom;
    data['idTo'] = this.idTo;
    data['timestamp'] = this.timestamp;
    data['content'] = this.content;
    data['type'] = this.type;
    return data;
  }
}

class MessageType {
  // type: 0 = text, 1 = image, 2 = sticker
  static const String TEXT = 'TEXT';
  static const String IMAGE = 'IMAGE';
  static const String STICKER = 'STICKER';
}
