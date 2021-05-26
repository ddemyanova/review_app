import 'package:flutter/material.dart';
import 'package:review_app/Screens/Home/appBar.dart';
import 'package:review_app/Screens/Home/body.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Body(),
      appBar: AppBarHome()
    );
  }
}
