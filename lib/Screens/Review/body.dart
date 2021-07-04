// @dart=2.13
import 'dart:convert';
import 'dart:io';
import 'package:review_app/checkData.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter/material.dart';
import 'package:review_app/Models/ProductsData.dart';
import 'package:review_app/Models/ReviewData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../components.dart';
import '../../constants.dart';
import 'getData.dart';

class Body extends StatefulWidget {
  final Product product;
  Body({ required this.product});
  @override
  _BodyState createState() => _BodyState(product: product);
}

class _BodyState extends State<Body> {
   final Product product;
   _BodyState({ required this.product});
  bool _isLogged = false;
  void initState(){

    super.initState();
  }

  void addReview(String review, int rate) async {
      var JsonData = null;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      print(review);
      Map data = {
        "rate": rate.toString(),
        "text": review
      };
      if (token != null) {
        var response = await http.post(
            Uri.parse(URL + "reviews/" + product.Id.toString()),
            body: data,
            headers: {
              'Authorization': 'Token ' + token,
            }
        );
        setState(() {
          reviewController.text="";
          _currentRating=0;
          if (response.statusCode == 200) {
            JsonData = json.decode(response.body);
            if (JsonData != null) {
              if (JsonData['success'] == true) {
                ShowToast("Review added!");
              }
              else {
                ShowToast("Error!");
              }
            }
          }
          else {
            ShowToast("Error!");
          }
        });
      }

  }
   double _currentRating = 0;
   TextEditingController reviewController = new TextEditingController();
  @override
  Widget build(BuildContext context) {

    final  _isKeyboard=MediaQuery.of(context).viewInsets.bottom!=0;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: PrimaryLightColor,
      body: FutureBuilder(
        future: checkConn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData)
          {
            bool _isConnected = false;
            _isConnected= snapshot.data! ;
            if(_isConnected){

              return FutureBuilder(
                future: checkLogin(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
                  if(snapshot.hasData){
                    _isLogged=snapshot.data!;

                    return FutureBuilder(
                      future: _isConnected? getReviews(product):null,
                      builder: (BuildContext context, AsyncSnapshot<List<Review>> snapshot) {
                        if (snapshot.hasData)
                        {
                          List<Review>? reviews = snapshot.data;
                          return Column
                            (
                            children: <Widget>[
                              Container(
                                child: Text(
                                  product.Title,
                                  style:TextStyle(height: 2, fontSize: 20),
                                ),
                              ),
                              Container(
                                child: Image.network(URL_IMG+product.Image),
                                height: 180,
                              ),
                              Container(
                                  child: Text(product.Text)
                              ),
                              _isLogged? Container(
                                width: 370,
                                height: 60,
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                                decoration: BoxDecoration(
                                  color:Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.5,
                                  ),

                                ),
                                child: TextField(
                                  controller: reviewController,
                                  decoration: InputDecoration(
                                    hintText: "Enter a comment",
                                  ),
                                ),
                              ): Container(),
                              _isLogged? SmoothStarRating(
                                starCount: 5,
                                isReadOnly: false,
                                size: 20,
                                rating: _currentRating,
                                color:Colors.yellow,
                                borderColor: Colors.yellow,
                                allowHalfRating: false,
                                onRated: (value){
                                  setState(() {
                                    _currentRating=value;
                                  });
                                },
                              ): Container(),
                              _isLogged? Container(
                                  margin: const EdgeInsets.all(10.0),
                                  child: MainButton(
                                    press:() {
                                      FocusScopeNode currentFocus = FocusScope.of(context);

                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      addReview(reviewController.text, _currentRating.toInt());
                                    },
                                    text: "Send review",
                                    backgroundColor: PrimaryColor,
                                  )): Container(),

                              Expanded(

                                  child:
                                  ReviewList(reviews: reviews))
                            ],
                          );
                        }
                        else
                        {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                  }
                  else
                    {
                      ShowToast("Lost Connection");
                      return Center(child: CircularProgressIndicator());
                    }
                },
              );
            }
            else {
              return Center(
                child:Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        product.Title,
                        style:TextStyle(height: 2, fontSize: 20),
                      ),
                    ),
                    Container(
                      child: Image.file(File(product.Image)),
                      height: 230,
                    ),
                    Container(
                        child: Text(product.Text)
                    ),
                  ],
                ),
              );
            }
          }
          else
          {
            ShowToast("Lost Connection");
            return Center(child: CircularProgressIndicator());
          }
        }

      ),

    );
  }
}

class ReviewList extends StatelessWidget {
  const ReviewList({
    Key? key,
    required this.reviews,
  }) : super(key: key);

  final List<Review>? reviews;

  @override
  Widget build(BuildContext context) {
    return 
        ListView(
          children: reviews!.map(
                  (Review review) => Card(
                margin: EdgeInsets.all(10.0),
                child:Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      title:  Text("${review.Text}"),
                      subtitle:Text("Rate: "+review.Rate.toString()),
                      leading: Container(
                          child:Icon(
                          Icons.account_circle_outlined,
                          ),
                        height:100,
                      ),
                    ),
                  ],
                )   ,
              )
          )
              .toList(),
        );
  }
}



