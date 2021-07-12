import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:review_app/DataProvider/Database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

import '../../Models/ProductsData.dart';

import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Product>> getProducts() async {

  var response = await http.get(
      Uri.parse(URL + "products")
  );
  if (response.statusCode == 200)
  {
    List<dynamic> body = jsonDecode(response.body);

    List<Product> products = body.map((dynamic item) => Product.fromJson(item),).toList();
    return products;
  }
  else
    {
    throw "Unable to read products.";
    }
}


