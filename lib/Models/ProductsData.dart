import 'package:flutter/material.dart';

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
}