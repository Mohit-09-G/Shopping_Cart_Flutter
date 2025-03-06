import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop/database/dbhelper.dart';
import 'package:shop/models/all_products.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/routes/route.dart' as route;
import 'package:shop/screens/add_to_cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<int, List<ProductModel>>> allProducts = [];

  Map<int, List<ProductModel>> newallProducts = {};
  List<ProductModel> products = [];

  @override
  void initState() {
    fetchList();
    getInitialData();
    super.initState();
  }

  Future<void> getInitialData() async {
    AllProductsModel allProductsModel =
        await DatabaseHelper.instance.queryAllProductsModel();
    mergeProducts(allProducts, allProductsModel.productGroups);
  }

  void mergeProducts(List<Map<int, List<ProductModel>>> allProducts,
      List<Map<int, List<ProductModel>>> productGroups) {
    for (var productMap in allProducts) {
      productMap.forEach((productKey, productList) {
        bool keyFound = false;

        // Check if the key exists in any map within productGroups
        for (var groupMap in productGroups) {
          if (groupMap.containsKey(productKey)) {
            // If key exists, add all products from productGroups to allProducts
            productList.addAll(groupMap[productKey]!);
            keyFound = true;
            break;
          }
        }

        // If key wasn't found in productGroups, add an empty list
        if (!keyFound) {
          productList.addAll([]); // Adding empty list for missing keys
        }
      });
    }
    setState(() {});
  }

  Future<void> fetchList() async {
    List<Map<String, dynamic>> x =
        await DatabaseHelper.instance.queryAllProduct();

    setState(() {
      products = x.map((product) => ProductModel.fromMap(product)).toList();
      for (var i = 0; i < products.length; i++) {
        allProducts.add({products[i].id: []});
      }
    });
  }

  void addProduct(ProductModel product) {
    bool productAdded = false;

    for (var productMap in allProducts) {
      if (productMap.containsKey(product.id)) {
        productMap[product.id]?.add(product);
        productAdded = true;
        break;
      }
    }

    if (!productAdded) {
      allProducts.add({
        product.id: [product]
      });
    }

    _updateAllProductsModelInDb();
  }

  void _updateAllProductsModelInDb() async {
    try {
      AllProductsModel allProductsModel =
          AllProductsModel(productGroups: allProducts);

      await DatabaseHelper.instance.insertAllProducts(allProductsModel);
      allProductsModel = await DatabaseHelper.instance.queryAllProductsModel();
      setState(() {
        allProducts = allProductsModel.productGroups;
      });
    } catch (e) {
      print("Error updating AllProductsModel in DB: $e");
    }
  }

  void removeProduct(ProductModel product) async {
    for (var group in allProducts) {
      if (group.containsKey(product.id)) {
        List<ProductModel> productList = group[product.id] ?? [];

        productList.removeAt(productList.length - 1);

        group[product.id] = productList;
        break;
      }
    }

    AllProductsModel allProductsModel1 =
        AllProductsModel(productGroups: allProducts);
    await DatabaseHelper.instance.deleteProductFromGroup(allProductsModel1);

    AllProductsModel allProductsModel =
        await DatabaseHelper.instance.queryAllProductsModel();
    setState(() {
      allProducts = allProductsModel.productGroups;
    });
  }

  void mergeMapData(
    List<Map<int, List<ProductModel>>> allProducts,
    List<Map<int, List<ProductModel>>> result,
  ) {
    for (var resultMap in result) {
      resultMap.forEach((key, value) {
        bool found = false;
        for (var allProductMap in allProducts) {
          if (allProductMap.containsKey(key)) {
            found = true;

            if (value is Map && allProductMap[key] is Map) {
              mergeMapData(
                allProductMap[key] as List<Map<int, List<ProductModel>>>,
                value as List<Map<int, List<ProductModel>>>,
              );
            } else {
              allProductMap[key] = value;
            }
            break;
          }
        }

        if (!found) {
          allProducts.add({key: value});
        }
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await DatabaseHelper.instance.clearUserStatus();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  route.loginpage,
                  (route) => false,
                );
              },
              icon: Icon(Icons.logout_outlined))
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFFFFFF),
        title: Text(
          "Products",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              textStyle: TextStyle(color: Colors.black)),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: products.isNotEmpty
                ? GridView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.8,
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0),
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3,
                        child: Container(
                          color: Color(0xFFFFFFFF),
                          //height: 700,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Card(
                                    margin: EdgeInsets.all(10),
                                    shadowColor: Color(0xFF000000),
                                    elevation: 5,
                                    child: Image.asset(
                                      products[index].productImage,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(products[index].productPrice,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(fontSize: 12),
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF6CC51D),
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    products[index].productName,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(fontSize: 15),
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF000000)),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    products[index].productQuantity,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(fontSize: 12),
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF868889)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: Color(0xFFEBEBEB),
                                      height: 2,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    allProducts[index][index]!.isNotEmpty
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  removeProduct(
                                                      products[index]);
                                                },
                                                child: Image.asset(
                                                  "assets/icons/minus.png",
                                                  height: 15,
                                                  width: 15,
                                                ),
                                              ),
                                              Text(
                                                allProducts[index][index]!
                                                    .length
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0XFF000000),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  addProduct(products[index]);
                                                },
                                                child: Image.asset(
                                                  "assets/icons/plus.png",
                                                  height: 15,
                                                  width: 15,
                                                ),
                                              ),
                                            ],
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              addProduct(products[index]);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/basket.png",
                                                  height: 15,
                                                  width: 15,
                                                ),
                                                Container(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Add to cart",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0XFF000000),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : CircularProgressIndicator(
                    color: Colors.blueAccent,
                  ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 200.0,
                        child: ElevatedButton(
                          onPressed: () async {
                            List<Map<int, List<ProductModel>>> result =
                                await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddToCart(cartItems: allProducts),
                              ),
                            );

                            allProducts.clear();
                            for (var i = 0; i < products.length; i++) {
                              allProducts.add({products[i].id: []});
                            }
                            mergeMapData(allProducts, result);
                          },
                          child: Text(
                            "Cart",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          // ElevatedButton(
          //     onPressed: () async {
          //       await DatabaseHelper.instance.clearUserStatus();
          //       Navigator.pushNamedAndRemoveUntil(
          //         context,
          //         route.loginpage,
          //         (route) => false,
          //       );
          //     },
          //     child: Text("Logout"))
        ],
      ),
    );
  }
}
