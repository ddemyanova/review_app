import 'package:flutter/material.dart';
import 'package:review_app/Screens/Home/homeScreen.dart';
import 'package:review_app/Screens/Login/loginScreen.dart';
import 'package:review_app/Screens/SignUp/signupScreen.dart';
import 'package:review_app/constants.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset("assets/images/bg.jpg"),
          ),
          Positioned(
              top: 600,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginScreen();
                      }));
                    },
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16),
                        backgroundColor: PrimaryColor,
                        fixedSize: Size(300, 50)),
                    child:
                        Text("LOGIN", style: TextStyle(color: Colors.white))),
              )),
          Positioned(
              top: 665,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: TextButton(
                    onPressed: () {Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return SignupScreen();
                        }));
                    },
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16),
                        backgroundColor: PrimaryLightColor,
                        fixedSize: Size(300, 50)),
                    child:
                        Text("SIGNUP", style: TextStyle(color: Colors.white))),
              )),
          Positioned(
              top: 730,
              child: TextButton(
                  onPressed: () {

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return HomeScreen();
                        }));
                  },
                  child: Text("Skip",
                      style: TextStyle(color: Colors.black45, fontSize: 16))))
        ],
      ),
    );
  }
}
