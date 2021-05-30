import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:review_app/Models/ProductsData.dart';
import 'package:review_app/Screens/Home/appBar.dart';
import 'package:review_app/Screens/Login/loginScreen.dart';
import 'package:review_app/Screens/Review/reviewScreen.dart';
import 'package:review_app/Screens/Welcome/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import 'getData.dart';
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
        future: getProducts(),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
           if (snapshot.hasData)
           {
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
                                child: Image.network(URL_IMG+product.Image),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              title: Text(product.Title),
                              trailing:  Icon(
                                  Icons.download_rounded,
                                color: _isLogged? PrimaryColor: Colors.black54,
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
          else
            {
            return Center(child: CircularProgressIndicator());
            }
        },
      ),

    );
  }
}


