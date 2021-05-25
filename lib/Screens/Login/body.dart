import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:review_app/Screens/Home/homeScreen.dart';
import 'package:review_app/Screens/Welcome/welcome.dart';
import '../../components.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {

    TextEditingController loginController = new TextEditingController();
    TextEditingController passController = new TextEditingController();
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child:
      _isLoading? Center(child: CircularProgressIndicator()):
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          //Login field
          Positioned(
              top:300,
              child: Container(
                width: 300,
                height: 50,
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color:PrimaryLightColor,
                  borderRadius: BorderRadius.circular(30),

                ),
                child: TextField(
                  controller: loginController,
                  decoration: InputDecoration(
                      hintText: "Login",
                      icon: Icon(
                        Icons.person,
                        color: PrimaryColor,
                      ),
                      border: InputBorder.none
                  ),
                ),
              )
          ),

          //Password field
          Positioned(
              top:380,
              child: Container(
                width: 300,
                height: 50,
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color:PrimaryLightColor,
                  borderRadius: BorderRadius.circular(30),

                ),
                child: TextField(
                  obscureText:true,
                  controller: passController,
                  decoration: InputDecoration(
                      icon: Icon(
                          Icons.vpn_key,
                          color: PrimaryColor
                      ),
                      hintText: "Password",
                      border: InputBorder.none,
                      suffixIcon: Icon(
                          Icons.visibility,
                          color: PrimaryColor,

                      ),

                  ),
                  onChanged: (value){},
                ),
              )
          ),

          //Button Login
          Positioned(
              top: 600,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      Login(loginController.text, passController.text);
                    },
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16),
                        backgroundColor: PrimaryColor,
                        fixedSize: Size(300, 50)),
                    child:
                    Text("LOGIN", style: TextStyle(color: Colors.white))),
              )),
          Positioned(
              top: 670,
              child: TextButton(
                  onPressed: () {Navigator.pop(context);},
                  child: Text("Go back",
                      style: TextStyle(color: Colors.black45, fontSize: 16))))
        ],
      ),
    );
  }

  Login(String login, String password) async{
    var JsonData=null;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map data = {
      "username": login,
      "password": password
    };
   var response = await http.post(
        Uri.parse(URL + "login/"),
        body: data,
    );
    if(response.statusCode==200){
      JsonData=json.decode(response.body);
      if(JsonData!=null) {
        setState(() {
        _isLoading=false;
        if(JsonData['token']!=null) {

          preferences.setString( "token", JsonData['token']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context)=>HomeScreen()
              ),
                  (Route<dynamic> route) => false);
        }
        else{
          setState(() {
            ShowToast("Wrong login or password!");
            _isLoading = false;
          });
        }
      });
      }
    }
    else {
      setState(() {
        ShowToast("Wrong login or password!");
        _isLoading = false;
      });
      print(response.body);
    }
  }
  ShowLoginError(){
  }
}

