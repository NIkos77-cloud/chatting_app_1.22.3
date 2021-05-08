import 'dart:convert';
import 'dart:io';

import 'package:chat_app/src/Database/database_service.dart';
import 'package:chat_app/src/Model/login_model.dart';
import 'package:chat_app/src/Preferences/preference_key.dart';
import 'package:chat_app/src/Views/Home/home_page.dart';
import 'package:chat_app/src/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuth {
  Future<void> googleAuth(BuildContext context) async {
    final _auth = FirebaseAuth.instance;

    Indicators().indicatorPopupWillNotPop(context);
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );
    try {
      // gooogle auth
      final _user = await _googleSignIn.signIn();
      await _googleAuthCredential(_user, _auth, context);
    } catch (error) {
      print(error);
      Indicators().hideIndicator(context);
    }
  }

  Future<void> emailAuth(
      BuildContext context, String email, String password, String name) async {
    final _auth = FirebaseAuth.instance;
    final _database = DatabaseService();
    Indicators().indicatorPopupWillNotPop(context);
    try {
      UserCredential _userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      String url = Variables.defaultImage;
      await _database.insertUser(
        email: email,
        name: name,
        uid: _userCredential.user.uid,
        photoURL: url,
      );
      await _convertToJson(email, _userCredential.user.uid, name, url, context);
    } catch (e) {
      print(e);
      Indicators().hideIndicator(context);
    }
  }

  Future<void> loginWithEmail(
      String email, String password, BuildContext context) async {
    final _auth = FirebaseAuth.instance;
    final _database = DatabaseService();

    UserCredential _user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    UserModel _userData = await _database.getUser(_user.user.uid);

    await _convertToJson(email, _user.user.uid, _userData.displayName,
        _userData.photoUrl, context);
  }

  Future<void> _googleAuthCredential(GoogleSignInAccount _user,
      FirebaseAuth _auth, BuildContext context) async {
    final _database = DatabaseService();
    final googleSignInAuthentication = await _user.authentication;
    OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    await _database.insertUser(
      email: userCredential.user.email,
      name: userCredential.user.displayName,
      uid: userCredential.user.uid,
      photoURL: userCredential.user.photoURL,
    );
    User _userData = userCredential.user;
    await _convertToJson(
      _userData.email,
      _userData.uid,
      _userData.displayName,
      _userData.photoURL,
      context,
    );
  }

  Future<void> _convertToJson(String email, String uid, String name,
      String photoURL, BuildContext context) async {
    UserModel _userModel = UserModel(
      email: email,
      id: uid,
      displayName: name,
      photoUrl: photoURL,
    );
    UserModel user = UserModel.fromJson(_userModel.toJson());
    Variables.user = user;
    Variables.prefs
        .setString(PreferenceKey.USER_DATA, json.encode(_userModel.toJson()));

    Navigator.of(context).pushAndRemoveUntil(
      FadeRoute(
        page: HomePage(),
      ),
      (route) => false,
    );
  }
}
