import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:review_app/constants.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../components.dart';
import '../Models/ProductsData.dart';
class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  late Database _database;
  bool _dbCheck = false;
  Future<Database> get database async {
    print("database getter called");

    if (_dbCheck ==true) {

      return _database;
    }
    _dbCheck=true;
    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'Products.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating product table");

        await database.execute(
          "CREATE TABLE PRODUCTS ("
              "id INTEGER PRIMARY KEY,"
              "image TEXT,"
              "title TEXT,"
              "text TEXT"
              ")",
        );
      },
    );
  }

  // newProduct(Product product) async {
  //
  //   final db = await database;
  //   //insert to the table using the new id
  //   var raw = await db.rawInsert(
  //       "INSERT Into Product (id,image,title,text)"
  //           " VALUES (?,?,?,?)",
  //       [product.Id, product.Image, product.Title, product.Text]);
  //
  //   return raw;
  // }
  Future<List<Product>> getProductsDB() async {
    final db = await database;

    var foods = await db
        .query('PRODUCTS', columns: ['id', 'image', 'title', 'text']);

     List<Product>  list = [];

    foods.forEach((current) {
      Product product = Product.fromMap(current);
      list.add(product);
    });

    return list;
  }

  Future<Product> newProduct(Product product) async {
    final db = await database;
    try{
      if(await added(product.Id)){
        print("added");
        return product;
      }
      else{
        print("new");
        product.Id = await db.insert('PRODUCTS', product.toMap());
        print("Success");
      }

    }
    catch(e){
      print(e.toString()+' error while adding product');
    }
    return product;
  }

  Future<bool> added(int id) async{
    final db = await database;
    try {
      int? count = Sqflite.firstIntValue(
          await db.rawQuery("SELECT COUNT(*) FROM PRODUCTS WHERE Id=$id"));
      if(count==1) return true;
      else return false;
    }
    catch(e){
      print(e.toString());
      return false;
    }
  }

  deleteAll() async {
    try{
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'Products.db');
      await deleteDatabase(path);
      _dbCheck=false;
      print('DB was deleted');}
    catch(E){
      print(E.toString());
    }
  }
}