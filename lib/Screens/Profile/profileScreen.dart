
import 'package:flutter/material.dart';
import 'package:review_app/Screens/Profile/body.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Body(),
      appBar: AppBar(
        title: Text("Profile"),
      ),
    );
  }
}