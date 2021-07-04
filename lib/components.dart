import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:review_app/constants.dart';
ShowToast(String text){
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black26,
      textColor: Colors.black,
      fontSize: 16.0
  );
}

class MainButton extends StatelessWidget {
  final String text;
  final void Function() press;
  final Color backgroundColor;
  MainButton({ required this.text, required this.press, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: TextButton(
          onPressed: press,
          style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16),
              backgroundColor: backgroundColor,
              fixedSize: Size(300, 50)),
          child:
          Text(text, style: TextStyle(color: Colors.white))),
    );
  }
}

class MainTextField extends StatelessWidget {
  const MainTextField({
    required this.controller,
    this.icon,
    required this.text,
    this.suffixIcon,
    this.obscure = false,
    this.press,

  }) : super();

  final TextEditingController controller;
  final Icon? icon;
  final String text;
  final IconButton? suffixIcon;
  final bool obscure;
  final void Function()? press;
  @override
  Widget build(BuildContext context) {
    return Container
      (
      width: 300,
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color:PrimaryLightColor,
        borderRadius: BorderRadius.circular(30),

      ),
      child: TextField(
        obscureText: obscure,
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          icon: icon,
          border: InputBorder.none,
          suffixIcon:suffixIcon,
        ),
        onChanged: (value){},
      ),
    );
  }
}

class LightButton extends StatelessWidget {
  const LightButton({
    required this.text,
    required this.press,
  }) : super();

  final String text;
  final void Function()? press;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: press,
        child: Text(text,
            style: TextStyle(color: Colors.black45, fontSize: 16)));
  }
}
