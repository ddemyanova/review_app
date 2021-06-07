import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:review_app/Models/ProductsData.dart';
import 'package:review_app/Models/ReviewData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';

Future<List<Review>> getReviews(Product product) async {

  var response = await http.get(
      Uri.parse(URL + "reviews/"+ product.Id.toString())
  );
  if (response.statusCode == 200)
  {
    List<dynamic> body = jsonDecode(response.body);
    List<Review> reviews = body.map((dynamic item) => Review.fromJson(item),).toList();

    return reviews;
  }
  else
  {
    throw "Unable to read products.";
  }
}

