import 'dart:io';

import 'package:chat_app/src/Model/chat_model.dart';
import 'package:chat_app/src/Model/login_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  final _database = FirebaseFirestore.instance;

  // Users
  Future<void> insertUser(
      {String name, String uid, String email, String photoURL}) async {
    DocumentReference _reference = _database.collection('users').doc(uid);
    await _reference.set({
      'name': name,
      'uid': uid,
      'email': email,
      'photo': photoURL,
      'createdAt': DateTime.now().toString(),
    });
  }

  Future<AllUserModel> getAllUsers() async {
    CollectionReference _reference = _database.collection('users');
    QuerySnapshot _querySnapshot = await _reference.get();
    return AllUserModel.fromJson(_querySnapshot.docs);
  }

  Future<UserModel> getUser(String id) async {
    DocumentReference _reference = _database.collection('users').doc(id);
    DocumentSnapshot _docSnapshot = await _reference.get();
    return UserModel.fromJson(_docSnapshot.data());
  }

  Future updateUser(String userId, Map<String, dynamic> newData) async {
    DocumentReference _reference = _database.collection('users').doc(userId);
    await _reference.update(newData);
  }

  Future sendMessage(String groupId, Map<String, dynamic> data) async {
    final documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(groupId)
        .collection(groupId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        data,
      );
    });
  }

  Future<String> uploadImage(File imageFile, String path) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child('$path$fileName');
    UploadTask uploadTask = reference.putFile(imageFile);
    var downladURL = await (await uploadTask).ref.getDownloadURL();
    String url = downladURL.toString();
    return url;
  }

  Future<ChatModel> getChatHistory(String groupChatId, int limit) async {
    QuerySnapshot _query = await FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();

    return ChatModel.fromJson(_query.docs);
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
