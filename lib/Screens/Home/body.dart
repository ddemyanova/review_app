import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:review_app/Models/Database.dart';
import 'package:review_app/Models/ProductsData.dart';
import 'package:review_app/Screens/Home/appBar.dart';
import 'package:review_app/Screens/Login/loginScreen.dart';
import 'package:review_app/Screens/Review/reviewScreen.dart';
import 'package:review_app/Models/Database.dart';
import 'package:review_app/Screens/Welcome/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components.dart';
import '../../constants.dart';
import 'getData.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import 'homeScreen.dart';
class Body extends StatefulWidget {

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isLogged =false;



  @override
  void initState(){

    super.initState();
    _isLogged = false;
    checklogin();
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

    // var response = await Dio().get(
    //     'https://helpx.adobe.com/content/dam/help/en/stock/how-to/visual-reverse-image-search/jcr_content/main-pars/image/visual-reverse-image-search-v2_intro.jpg',
    //     options: Options(responseType: ResponseType.bytes));
    // final result = await ImageGallerySaver.saveImage(
    //   Uint8List.fromList(response.data),
    //   quality: 60,
    //   name: 'file',
    // );
    //var imageId = await ImageDownloader.downloadImage("https://raw.githubusercontent.com/wiki/ko2ic/image_downloader/images/flutter.png");
    // String path =  result['filePath'].toString().replaceFirst('file://', '');
    // print("res: "+result.toString());
    //print(imageId);
    //product.Image=path;
    //DBProvider.db.newProduct(product);
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
  void checklogin() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.getString("token"));
    if(sharedPreferences.getString("token")!=null) {
      _isLogged=true;
    }
    else {
      _isLogged=false;
    }
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
            //
            return FutureBuilder(
              future: _isConnected? getProducts(): DBProvider.db.getProductsDB(),
                builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot){
                  if(snapshot.hasData){
                    List<Product>? products = snapshot.data;
                    return Stack(

                      children: <Widget>[

                        Positioned(
                          top: 0,
                          left: 0,
                          child: Image.asset("assets/images/bg.jpg"),
                        ),

                        ListView(
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
                                            color: _isLogged? PrimaryColor: Colors.black54),
                                        onPressed: () {
                                          if (_isLogged) {
                                            DBProvider.db.deleteAll();
                                            //downloadProduct(product);
                                          }
                                        },

                                      ),

                                    ),

                                  ],
                                )   ,
                                color: PrimaryLightColor,
                              )
                          )
                              .toList(),
                        ),
                      ]
                      ,
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
        },
      ),

    );
  }
}


