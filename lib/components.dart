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