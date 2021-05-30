
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:review_app/Screens/Home/homeScreen.dart';
import '../../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  TextEditingController nameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  late PickedFile _image ;
  bool img=false;

  PickImage() async{
    var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      print(image!.path);
      _image = image as PickedFile;
      img=true;
    });
  }
  SaveInfo(String name, String lastName, String path) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('name', name);
    preferences.setString('lastName', lastName);
    preferences.setString('image', path);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen()
        ),
            (Route<dynamic> route) => false);

  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[

          //name field
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
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Name",
                    border: InputBorder.none,

                  ),

                ),
              )
          ),

          //last name field
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
                  controller: lastNameController,
                  decoration: InputDecoration(
                      hintText: "Last name",
                      border: InputBorder.none
                  ),
                ),
              )
          ),

          //avatar field
          Positioned(
            top:450,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: img ? FileImage(File(_image.path)) :
                Image.asset("assets/images/avatar.png").image,
              ),
          ),


          //avatar button
          Positioned(
              top: 570,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: TextButton(
                    onPressed: () {
                      PickImage();
                    },
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16),
                        backgroundColor: PrimaryColor,
                        fixedSize: Size(150, 50)),
                    child:
                    Text("Browse image", style: TextStyle(color: Colors.white))),
              )),

          Positioned(
              top: 650,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: TextButton(
                    onPressed: () {
                      SaveInfo(nameController.text, lastNameController.text, _image.path);
                    },
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16),
                        backgroundColor: PrimaryColor,
                        fixedSize: Size(300, 50)),
                    child:
                    Text("SAVE", style: TextStyle(color: Colors.white))),
              )),
        ],
      ),
    );
  }
}
