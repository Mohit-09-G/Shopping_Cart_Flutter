import 'dart:convert';

import 'package:path/path.dart';
import 'package:shop/models/all_products.dart';
import 'package:shop/models/product_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  static const int _databaseVersion = 2;

  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<void> deleteDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'shop.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'shop.db');

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE product_table (
        id INTEGER PRIMARY KEY,
        productName TEXT,
        productImage TEXT,
        productPrice TEXT,
        productQuantity TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE all_products_table (
        id INTEGER PRIMARY KEY,
        allProductsJson TEXT
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS product_table');
    await _onCreate(db, newVersion);
  }

  Future<int> insertItems(ProductModel productModel) async {
    try {
      Database db = await instance.db;
      return await db.insert('product_table', productModel.tomap());
    } catch (e) {
      print('Error inserting item: $e');
      rethrow;
    }
  }

  Future<int> insertAllProducts(AllProductsModel allProductsModel) async {
    try {
      Database db = await instance.db;
      String allProductsJson = json.encode(allProductsModel.toMap());
      return await db.insert('all_products_table', {
        'allProductsJson': allProductsJson,
      });
    } catch (e) {
      print('Error inserting all products: $e');
      rethrow;
    }
  }

  Future<int> deleteProductFromGroup(AllProductsModel allProductsModel) async {
    try {
      Database db = await instance.db;

      var result = await db.query(
        'all_products_table',
      );

      if (result.isNotEmpty) {
        String allProductsJson = json.encode(allProductsModel.toMap());
        return await db.update(
          'all_products_table',
          {'allProductsJson': allProductsJson},
        );
      }

      return 0;
    } catch (e) {
      print('Error deleting product from group: $e');
      rethrow;
    }
  }

  Future<AllProductsModel> queryAllProductsModel() async {
    Database db = await instance.db;
    List<Map<String, dynamic>> result = await db.query('all_products_table');
    List<AllProductsModel> allProducts = [];

    for (var row in result) {
      String allProductsJson = row['allProductsJson'];
      Map<String, dynamic> decodedMap = json.decode(allProductsJson);
      AllProductsModel allProductsModel = AllProductsModel.fromMap(decodedMap);
      allProducts.add(allProductsModel);
    }

    return allProducts.last;
  }

  Future<List<Map<String, dynamic>>> queryAllProduct() async {
    Database db = await instance.db;
    return await db.query('product_table');
  }

  Future<void> initializProducts() async {
    try {
      Database db = await instance.db;
      List<Map<String, dynamic>> existingProducts =
          await db.query('product_table');

      if (existingProducts.isEmpty) {
        List<ProductModel> products = [
          ProductModel(
            id: 0,
            productImage: "assets/products/product_one.png",
            productName: "Fresh Peach",
            productQuantity: "Dozen",
            productPrice: "\$8.00",
          ),
          ProductModel(
            id: 1,
            productImage: "assets/products/product_two.png",
            productName: "Avacoda",
            productQuantity: "2.0 lbs",
            productPrice: "\$7.00",
          ),
          ProductModel(
            id: 2,
            productImage: "assets/products/product_threee.png",
            productName: "Pineapple",
            productQuantity: "1.50 lbs",
            productPrice: "\$9.90",
          ),
          ProductModel(
            id: 3,
            productImage: "assets/products/product_four.png",
            productName: "Black Grapes",
            productQuantity: "5.0 lbs",
            productPrice: "\$7.05",
          ),
          ProductModel(
            id: 4,
            productImage: "assets/products/product_five.png",
            productName: "Pomegranate",
            productQuantity: "1.50 lbs",
            productPrice: "\$2.09",
          ),
          ProductModel(
            id: 5,
            productImage: "assets/products/product_six.png",
            productName: "Fresh BRoccoli",
            productQuantity: "1 Kg",
            productPrice: "\$3.00",
          ),
          ProductModel(
            id: 6,
            productImage: "assets/products/product_six.png",
            productName: "Fresh BRoccoli",
            productQuantity: "1 Kg",
            productPrice: "\$3.00",
          ),
          ProductModel(
            id: 7,
            productImage: "assets/products/product_five.png",
            productName: "Pomegranate",
            productQuantity: "1.50 lbs",
            productPrice: "\$2.09",
          )
        ];

        for (ProductModel items in products) {
          await insertItems(items);
        }
      }
    } catch (e) {
      print('Error initializing products: $e');
      rethrow;
    }
  }
}
