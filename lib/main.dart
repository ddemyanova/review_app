import 'package:flutter/material.dart';
import 'package:review_app/Screens/Home/homeScreen.dart';
import 'package:review_app/Screens/Welcome/welcome.dart';
import 'package:review_app/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';
void main() {
  String? _token="";
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((instance) {
    _token = instance.getString("token");
    final _loggedIn = _token != null && _token != "";
    runApp(MyApp(loggedIn: _loggedIn));
  });
}

class MyApp extends StatelessWidget {
  final bool loggedIn;

  MyApp({ required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: PrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: loggedIn ? HomeScreen() : Welcome(),
    );
  }
}

