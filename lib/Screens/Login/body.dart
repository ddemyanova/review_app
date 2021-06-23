import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:review_app/Screens/Home/homeScreen.dart';
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
  bool _passObscure=true;
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

          //Button Login
          Container(
              margin:  EdgeInsets.symmetric( vertical: 20),
              child: MainButton(
                press:() {
                  setState(() {
                    _isLoading = true;
                  });
                  login(loginController.text, passController.text);
                },
                text:"Login",
                backgroundColor: PrimaryColor,
              ),
          ),
          LightButton(
            press:() {Navigator.pop(context);},
            text:"Go back",
          ),
        ],
      ),
    );
  }

  void login(String login, String password) async{
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
    }
  }
}

