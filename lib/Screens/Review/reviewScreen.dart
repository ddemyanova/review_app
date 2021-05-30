
import 'package:flutter/material.dart';
import 'package:review_app/Models/ProductsData.dart';
import 'package:review_app/Screens/Home/appBar.dart';
import 'package:review_app/Screens/Review/body.dart';

class ReviewScreen extends StatelessWidget {

  final Product product;
  ReviewScreen({ required this.product});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Body(product: product),
        appBar: AppBar()
    );
  }
}
