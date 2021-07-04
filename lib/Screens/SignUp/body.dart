import 'package:flutter/material.dart';
import 'package:review_app/Screens/Home/homeScreen.dart';
import 'package:review_app/Screens/Profile/profileScreen.dart';
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

  void signUp(String login, String password, String confirm) async{
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
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => new HomeScreen()),
                      (Route<dynamic> route) => false);
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
      }
    }
    else{
      setState(() {
        _isLoading = false;
      });
      ShowToast("Passwords are different!");
    }
  }

  bool _isLoading = false;
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
      child: _isLoading?
      Center(child: CircularProgressIndicator()):
      Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children: <Widget>[
          //Login field
           MainTextField(
                  controller: loginController,
                  icon: Icon(
                      Icons.person,
                      color: PrimaryColor
                  ),
                text:"Login"
           ),

          //Password field
          MainTextField(
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
            ),
            obscure: _passObscure,
            controller: passController,
            text:"Password",
            icon: Icon(
                Icons.vpn_key,
                color: PrimaryColor
            ),
          ),

          //Pass confirm
          MainTextField(
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
            ),
            obscure: _passConfirmObscure,
            controller: passConfirmController,
            text:"Password confirm",
            icon: Icon(
                Icons.vpn_key,
                color: PrimaryColor
            ),
          ),

          Container(
              margin:  EdgeInsets.symmetric( vertical: 10),
              child: MainButton(
                press:() {
                  setState(() {
                    _isLoading = true;
                  });
                  signUp(loginController.text, passController.text,passConfirmController.text);
                },
                text:"SIGN UP",
                backgroundColor: PrimaryColor,
              )
          ),
          //go back
          LightButton(
            press:() {Navigator.pop(context);},
            text:"Go back",
          ),
        ],
      ),
    );
  }
}



