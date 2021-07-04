
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:review_app/DataProvider/Database.dart';
import 'package:review_app/checkData.dart';
import 'package:review_app/Screens/Profile/profileScreen.dart';
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

  void OpenProfile(){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return ProfileScreen();
        }));
  }

  @override
  void initState(){
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder(
        future:checkLogin(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
          if(snapshot.hasData){
            _isLogged=snapshot.data!;
            if(_isLogged)
            return AppBar(

              title: Text("Products"),
              actions: [
                IconButton(
                  onPressed: (){
                    setState(() {
                      DBProvider.db.deleteAll();
                    });
                  },
                  icon: Icon(
                      Icons.delete
                  ),
                ),
                IconButton(
                  onPressed: (){
                    setState(() {
                      OpenProfile();
                    });
                  },
                  icon: Icon(
                      Icons.account_circle
                  ),
                ),
                IconButton(
                  onPressed: (){
                    logOut();
                  },
                  icon: Icon(
                      Icons.login
                  ),
                ),
              ],
            );
            else
              return AppBar(
                title: Text("Products"),
          );

          }
          else
            {
            return AppBar(
              title: Text("Products"),
            );
            }
        },
      ),
    );

  }
}
