import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:review_app/DataProvider/Database.dart';

class Product{
  int Id;
  String Title;
  String Image;
  String Text;
  Product({
    required this.Id,
    required this.Title,
    required this.Image,
    required this.Text,
  });
  factory Product.fromJson(Map<String, dynamic> json) {

    return Product(
      Id: json['id'] as int,
      Image: json['img'] as String,
      Title: json['title'] as String,
      Text: json['text'] as String,
    );
  }
  Map<String, dynamic> toMap()=> {
    'id': Id,
    'image': Image,
    'title': Title,
    'text': Text
  };
  factory Product.fromMap(Map<String, dynamic> map) {
   return Product(
    Id:map['id'],
    Image: map['image'],
    Title: map['title'],
    Text : map['text']
   );
  }
}

