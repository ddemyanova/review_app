import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Models/ProductsData.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  late Database _database;
  bool _dbCheck = false;
  Future<Database> get database async {
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
        return product;
      }
      else{
        product.Id = await db.insert('PRODUCTS', product.toMap());
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
    }
    catch(E){
      print(E.toString());
    }
  }
}