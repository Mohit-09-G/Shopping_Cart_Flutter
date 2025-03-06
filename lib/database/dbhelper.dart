import 'dart:convert';

import 'package:path/path.dart';
import 'package:shop/models/all_products.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  static const int _databaseVersion = 6;

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
    await db.execute('''
    CREATE TABLE user_detail (
      email TEXT PRIMARY KEY,
      password TEXT
    )
  ''');
    await db.execute('''
    CREATE TABLE user_status (
      email TEXT PRIMARY KEY,
      password TEXT
    )
  ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS product_table');
    await db.execute('DROP TABLE IF EXISTS all_products_table');
    await db.execute('DROP TABLE IF EXISTS user_detail');
    await db.execute('DROP TABLE IF EXISTS user_status');
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

  Future<int> insertUser(UserModel userModel) async {
    try {
      Database db = await instance.db;
      // String userModelJson = json.encode(userModel.usertomap());
      return await db.insert('user_detail', {
        'email': userModel.email,
        'password': userModel.password,
      });
    } catch (e) {
      print('error inserting user');
      rethrow;
    }
  }

  Future<int> clearUserStatus() async {
    try {
      Database db = await instance.db;

      // Delete all records from user_status table
      return await db.delete('user_status');
    } catch (e) {
      print('Error clearing user status: $e');
      rethrow;
    }
  }

  Future<int> userStatus(UserModel userModel) async {
    try {
      Database db = await instance.db;

      // Check if the user status already exists
      List<Map<String, Object?>> result = await db.query(
        'user_status',
        where: 'email = ?',
        whereArgs: [userModel.email],
      );

      if (result.isNotEmpty) {
        // Update the user status if it already exists
        return await db.update(
          'user_status',
          {
            'email': userModel.email,
            'password': userModel.password,
          },
          where: 'email = ?',
          whereArgs: [userModel.email],
        );
      } else {
        // Insert the user status if it doesn't exist
        return await db.insert(
          'user_status',
          {
            'email': userModel.email,
            'password': userModel.password,
          },
        );
      }
    } catch (e) {
      print('Error inserting or updating user status: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUserStatus() async {
    try {
      Database db = await instance.db;

      // Query the user_status table to get the data
      List<Map<String, Object?>> result = await db.query(
        'user_status',
      );

      // If there is data, return the UserModel
      if (result.isNotEmpty) {
        Map<String, Object?> userStatus = result[0];
        return UserModel(
          email: userStatus['email'] as String,
          password: userStatus['password'] as String,
        );
      }
      return null; // Return null if no data is found
    } catch (e) {
      print('Error fetching user status: $e');
      rethrow;
    }
  }

  Future<int> checkUserCredential(UserModel userModel) async {
    try {
      Database db = await instance.db;

      List<Map<String, Object?>> result = await db
          .query('user_detail', where: 'email=?', whereArgs: [userModel.email]);

      if (result.isNotEmpty) {
        String storedPassword = result[0]['password'] as String;

        if (storedPassword == userModel.password) {
          return 1;
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    } catch (e) {
      print("Error: $e");
      return -1;
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
