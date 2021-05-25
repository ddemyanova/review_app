
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:review_app/Screens/Welcome/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AppBarHome extends StatefulWidget implements PreferredSizeWidget{
  AppBarHome() : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;
  @override
  _AppBarHomeState createState() => _AppBarHomeState();
}

class _AppBarHomeState extends State<AppBarHome> {
  bool _isLogged = false;
  void logOut() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => Welcome()
        ),
            (Route<dynamic> route) => false);

  }
  void checklogin() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token")!=null) {
      _isLogged=true;
    }
    else {
      _isLogged=false;
    }
  }

  @override
  void initState(){
    checklogin();
  }
  @override
  Widget build(BuildContext context) {
    if(_isLogged)
    return AppBar(
          title: Text("Products"),

          actions: [
            IconButton(
              onPressed: (){
                logOut();
              },
              icon: Icon(
                  Icons.login
              ),
            )
          ],
    );
    else
      return AppBar(
        title: Text("Products"),
      );

  }
}
