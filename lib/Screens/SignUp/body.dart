import 'package:flutter/material.dart';
import 'package:review_app/Screens/Home/homeScreen.dart';
import 'package:review_app/Screens/SignUp/profileScreen.dart';
import 'package:review_app/Screens/Welcome/welcome.dart';
import 'package:review_app/constants.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../components.dart';

class Body extends StatefulWidget {

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isLoading = false;
  Signup(String login, String password, String confirm) async{
    if(password==confirm) {
      var JsonData = null;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      Map data = {
        "username": login,
        "password": password
      };
      var response = await http.post(
        Uri.parse(URL + "register/"),
        body: data,
      );
      if (response.statusCode == 201) {
        JsonData = json.decode(response.body);
        if (JsonData != null) {
          setState(() {
            _isLoading = false;
            if (JsonData['token'] != null) {
              preferences.setString("token", JsonData['token']);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return ProfileScreen();
                  }));
            }
            else {
              ShowToast("Wrong login or password!");
              setState(() {
                _isLoading = false;
              });
            }
          });
        }
      }
      else {
        ShowToast("Wrong login or password!");
        setState(() {
          _isLoading = false;
        });
        print(response.body);
      }
    }
    else{
      setState(() {
        _isLoading = false;
      });
      ShowToast("Passwords are different!");
    }
  }

  TextEditingController loginController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController passConfirmController = new TextEditingController();
  bool _passObscure = true;
  bool _passConfirmObscure = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: _isLoading? Center(child: CircularProgressIndicator()): Stack(
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
                          color: PrimaryColor
                      ),
                      border: InputBorder.none
                  ),
                ),
              )
          ),
          //Password field
          Positioned(
              top:360,
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
                  controller: passController,
                  obscureText:_passObscure,
                  decoration: InputDecoration(
                      icon: Icon(
                          Icons.vpn_key,
                          color: PrimaryColor
                      ),
                      hintText: "Password",
                      border: InputBorder.none,
                      suffixIcon:IconButton(
                        icon:Icon(
                          _passObscure? Icons.visibility_off: Icons.visibility,
                          color: PrimaryColor,
                        ),
                        onPressed: (){
                          setState(() {
                            _passObscure = !_passObscure;
                          });
                        },
                      )
                  ),
                  onChanged: (value){},
                ),
              )
          ),

          //Pass confirm
          Positioned(
              top:420,
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
                  controller: passConfirmController,
                  obscureText:_passConfirmObscure,
                  decoration: InputDecoration(
                      icon: Icon(
                          Icons.vpn_key,
                          color: PrimaryColor
                      ),
                      hintText: "Password confirm",
                      border: InputBorder.none,
                      suffixIcon:IconButton(
                        icon:Icon(
                          _passConfirmObscure? Icons.visibility_off: Icons.visibility,
                          color: PrimaryColor,
                        ),
                        onPressed: (){
                          setState(() {
                            _passConfirmObscure = !_passConfirmObscure;
                          });
                        },
                      )
                  ),
                  onChanged: (value){},
                ),
              )
          ),
          //Signup
          Positioned(
              top: 600,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      Signup(loginController.text, passController.text,passConfirmController.text);
                    },
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16),
                        backgroundColor: PrimaryColor,
                        fixedSize: Size(300, 50)),
                    child:
                    Text("SIGN UP", style: TextStyle(color: Colors.white))),
              )),
          //go back
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
}
