
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
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top:180,
              left:70,
              child: Text("Name"),
          ),
          //name field
          Positioned(
              top:200,
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
          Positioned(
            top:280,
            left:70,
            child: Text("Last name"),
          ),
          //last name field
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
                  controller: lastNameController,
                  decoration: InputDecoration(
                      hintText: "Last name",
                      border: InputBorder.none
                  ),
                ),
              )
          ),
          Positioned(
              top:370,
              child:   CircleAvatar(
                radius: 50,
                backgroundImage: img ? FileImage(File(path)) :
                Image.asset("assets/images/avatar.png").image,
              )
          ),
          //avatar field


          //avatar button
          Positioned(
              top: 480,
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
              top: 600,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: TextButton(
                    onPressed: () {
                      SaveInfo(nameController.text, lastNameController.text, path);
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
