import 'package:chat_app/src/Preferences/preference_key.dart';
import 'package:chat_app/src/Views/Home/home_page.dart';
import 'package:chat_app/src/constant.dart';
import 'package:chat_app/src/Views/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences.getInstance().then((prefs) {
    runApp(MyApp(prefs));
  });
}

class MyApp extends StatelessWidget {
  const MyApp(this._prefs);
  final SharedPreferences _prefs;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Cabin',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _decideScreen(),
    );
  }

  Widget _decideScreen() {
    Variables.prefs = _prefs;
    if (_prefs.containsKey(PreferenceKey.USER_DATA)) {
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}
