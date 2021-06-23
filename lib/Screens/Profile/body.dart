
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:review_app/Screens/Home/homeScreen.dart';
import '../../components.dart';
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
  String path ="";
  bool img=false;

  PickImage() async{
    var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      path= image!.path;
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
  InfoLoad() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = preferences.getString('name')!;
      lastNameController.text = preferences.getString('lastName')!;
      if(preferences.getString('image')!=""){
        path= preferences.getString('image')!;
        img=true;
      }
    });


    }


  @override
  void initState(){
    super.initState();
    InfoLoad();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: double.infinity,
      child: Column(

        mainAxisAlignment:MainAxisAlignment.center,
        children: <Widget>[

          //name field
          MainTextField(
              controller: nameController,
              text:"Name"
          ),

          //last name field
        MainTextField(
            controller: lastNameController,
            text:"Last name"
        ),
          Container(
              margin:  EdgeInsets.symmetric( vertical: 10),
              child:   CircleAvatar(
                radius: 50,
                backgroundImage: img ? FileImage(File(path)) :
                Image.asset("assets/images/avatar.png").image,
              )
          ),
          //avatar field

          Container(
            margin:  EdgeInsets.symmetric( vertical: 5),
            child: LightButton(
              press:() {
                PickImage();
              },
              text:"Browse image",
            ),
          ),
          //avatar button
          MainButton(
              text: "SAVE",
              press: () {
                SaveInfo(nameController.text, lastNameController.text, path);
              },
              backgroundColor: PrimaryColor),
          Container(
            margin:  EdgeInsets.symmetric( vertical: 5),
            child: LightButton(
              press:() {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen()
                    ),
                        (Route<dynamic> route) => false);
              },
              text:"Close",
            ),
          ),
        ],
      ),
    );
  }
}
