import 'package:flutter/material.dart';
import 'package:review_app/Screens/Welcome/welcome.dart';
import 'package:review_app/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: PrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Welcome(),
    );
  }
}

