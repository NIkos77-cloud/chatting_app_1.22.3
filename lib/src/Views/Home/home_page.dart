import 'dart:convert';

import 'package:chat_app/src/Database/database_service.dart';
import 'package:chat_app/src/Helper/location_helper.dart';
import 'package:chat_app/src/Model/login_model.dart';
import 'package:chat_app/src/Preferences/preference_key.dart';
import 'package:chat_app/src/Views/Home/user_list.dart';
import 'package:chat_app/src/Views/login.dart';
import 'package:chat_app/src/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final _database = DatabaseService();
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() {
    Map<String, dynamic> _data = json.decode(
      Variables.prefs.getString(PreferenceKey.USER_DATA),
    );
    Variables.user = UserModel.fromJson(_data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Variables.user.displayName == null
            ? Text('')
            : Variables.user.displayName.split(' ') != null
                ? Text('Hi, ${Variables.user.displayName.split(' ')[0]}')
                : Text('Hi, ${Variables.user.displayName}'),
        centerTitle: false,
        actions: [
          _logout(),
        ],
      ),
      body: UserList(),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.map),
      //   backgroundColor: Variables.appColor,
      //   onPressed: () {},
      // ),
    );
  }

  Widget _logout() {
    return Container(
      padding: EdgeInsets.all(10),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Text(
          'Logout',
          style: TextStyle(
            color: Variables.appColor,
          ),
        ),
        color: Colors.white,
        onPressed: () async {
          Variables.prefs.remove(PreferenceKey.USER_DATA);
          FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
          Navigator.pushAndRemoveUntil(
            context,
            FadeRoute(
              page: LoginPage(),
            ),
            (route) => false,
          );
        },
      ),
    );
  }
}
