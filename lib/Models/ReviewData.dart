import 'dart:ui';

import 'package:flutter/material.dart';

class Review{
  int Id;
  int Rate;
  int Id_user;
  String Text;
  int Id_entry;
  Review({
    required this.Id,
    required this.Rate,
    required this.Id_user,
    required this.Id_entry,
    required this.Text,
  });
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      Id: json['id'] as int,
      Rate: json['rate'] as int,
      Id_user: json['created_by']['id'] as int,
      Text: json['text'] as String,
      Id_entry: json['product'] as int,
    );
  }
}