import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:review_app/DataProvider/Database.dart';
import 'package:review_app/Models/ProductsData.dart';
import 'package:review_app/Screens/Home/appBar.dart';
import 'package:review_app/Screens/Login/loginScreen.dart';
import 'package:review_app/Screens/Review/reviewScreen.dart';
import 'package:review_app/DataProvider/Database.dart';
import 'package:review_app/Screens/Welcome/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components.dart';
import '../../constants.dart';
import 'getData.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import 'homeScreen.dart';
import 'package:review_app/checkData.dart';
class Body extends StatefulWidget {

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isLogged =false;
  @override
  void initState(){

    super.initState();
    checkConn();

  }
  Future<bool> getPermission ()async{
    Permission permission = Permission.storage;
    if(await permission.isGranted){
      print("granted");
      return true;

    }
    else{
      var result = await permission.request();
      if(result == PermissionStatus.granted){
        print("granted later");
        return true;

      }
      else{
        print("not granted");
        return false;

      }
    }
  }
  void downloadProduct(Product product) async{
    Directory directory ;
    try{
      if(await getPermission()){
        directory =(await getExternalStorageDirectory())!;
        print(directory.path);
        if(await directory.exists()){
          File saveFile = File(directory.path + '/'+product.Image);
          Dio dio =Dio();
          await dio.download(URL_IMG+product.Image, saveFile.path);

          Product prod = Product(
              Id:product.Id,
              Title: product.Title,
              Image: saveFile.path,
              Text:product.Text) ;

          DBProvider.db.newProduct(prod);
          setState(() {});
        }
      }
    }
    catch(e){
    }
    setState(() {
    });
  }



  void logOut() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => Welcome()
        ),
            (Route<dynamic> route) => false);

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: checkConn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
           if (snapshot.hasData)
           {
             bool _isConnected = false;
             _isConnected= snapshot.data! ;

            return FutureBuilder(
              future: checkLogin(),
              builder: (BuildContext context, AsyncSnapshot <bool> snapshot){
                if(snapshot.hasData)
                {
                  _isLogged = snapshot.data!;

                  return FutureBuilder(

                      future: _isConnected? getProducts(): DBProvider.db.getProductsDB(),
                      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot){
                        if(snapshot.hasData){
                          List<Product>? products = snapshot.data;
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/bg.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child:Column(
                              children: products!.map(
                                      (Product product) => Card(
                                    margin: EdgeInsets.all(10.0),
                                    child:Column(
                                      children: <Widget>[
                                        ListTile(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) {
                                                  return ReviewScreen(product: product);
                                                }));
                                          },
                                          leading: Container(
                                            child: _isConnected? Image.network(URL_IMG+product.Image):
                                            Image.file(File(product.Image)),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                          title: Text(product.Title),
                                          trailing:  IconButton(
                                            icon: Icon(
                                                Icons.download_rounded,
                                                color: (_isLogged & _isConnected)?
                                                PrimaryColor : Colors.black54),
                                            onPressed: () {
                                              if (_isLogged && _isConnected) {
                                                //DBProvider.db.deleteAll();
                                                downloadProduct(product);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    color: PrimaryLightColor,
                                  )
                              ).toList(),
                            ),
                          );
                        }
                        else{
                          ShowToast("Lost Connection");
                          return Center(child: CircularProgressIndicator());
                        }
                      }
                  );
                }
                else
                {
                  ShowToast("Lost Connection");
                  return Center(child: CircularProgressIndicator());
                }
              }
            );
          }
          else
            {
              ShowToast("Lost Connection");
              return Center(child: CircularProgressIndicator());
            }
        },
      ),
    );
  }
}


