import 'package:flutter/material.dart';
import 'package:review_app/Screens/Home/homeScreen.dart';
import 'package:review_app/Screens/Login/loginScreen.dart';
import 'package:review_app/Screens/SignUp/signupScreen.dart';
import 'package:review_app/constants.dart';
import '../../components.dart';

class Body extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment:MainAxisAlignment.end,
        children: <Widget>[
          Container(
              margin:  EdgeInsets.symmetric( vertical: 10),
              child: MainButton(
                press: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return LoginScreen();
                      }));
                },
                backgroundColor: PrimaryColor,
                text: "LOGIN",
              ),
          ),
          Container(
              margin:  EdgeInsets.symmetric( vertical: 10),
              child: MainButton(
                press:() {Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return SignupScreen();
                    }));
                },
                backgroundColor: PrimaryLightColor,
                text: "SIGNUP",
              ),
          ),
          Container(
              margin:  EdgeInsets.symmetric( vertical: 5),
              child: LightButton(
                press:() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return HomeScreen();
                      }));
                },
                text:"Skip",
              ),
          )
        ],
      ),
    );
  }
}

