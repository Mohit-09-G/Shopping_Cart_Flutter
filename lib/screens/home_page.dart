import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/screens/add_to_cart.dart';

List<ProductModel> products = [
  ProductModel(
      id: 0,
      productImage: "assets/products/product_one.png",
      productName: "Fresh Peach",
      productQuantity: "Dozen",
      productPrice: "\$8.00"),
  ProductModel(
      id: 1,
      productImage: "assets/products/product_two.png",
      productName: "Avacoda",
      productQuantity: "2.0 lbs",
      productPrice: "\$7.00"),
  ProductModel(
      id: 2,
      productImage: "assets/products/product_threee.png",
      productName: "Pineapple",
      productQuantity: "1.50 lbs",
      productPrice: "\$9.90"),
  ProductModel(
      id: 3,
      productImage: "assets/products/product_four.png",
      productName: "Black Grapes",
      productQuantity: "5.0 lbs",
      productPrice: "\$7.05"),
  ProductModel(
      id: 4,
      productImage: "assets/products/product_five.png",
      productName: "Pomegranate",
      productQuantity: "1.50 lbs",
      productPrice: "\$2.09"),
  ProductModel(
      id: 5,
      productImage: "assets/products/product_six.png",
      productName: "Fresh BRoccoli",
      productQuantity: "1 Kg",
      productPrice: "\$3.00"),
      
  ProductModel(
      id: 6,
      productImage: "assets/products/product_six.png",
      productName: "Fresh BRoccoli",
      productQuantity: "1 Kg",
      productPrice: "\$3.00"),
  ProductModel(
      id: 7,
      productImage: "assets/products/product_five.png",
      productName: "Pomegranate",
      productQuantity: "1.50 lbs",
      productPrice: "\$2.09")
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<int, List<ProductModel>>> allProducts = [];

  @override
  void initState() {
    for (var i = 0; i < products.length; i++) {
      allProducts.add({products[i].id: []});
    }
    super.initState();
  }

// Function to add products to the list of maps
  void addProduct(ProductModel product) {
    bool productAdded = false;

    // Iterate through the list of maps to find if the product ID exists
    for (var productMap in allProducts) {
      if (productMap.containsKey(product.id)) {
        // If the product ID exists in the map, add to the list
        productMap[product.id]?.add(product);
        productAdded = true;
        break;
      }
    }

    // If product ID was not found, create a new map and add it to the list
    if (!productAdded) {
      allProducts.add({
        product.id: [product]
      });
    }
    setState(() {});
  }

  void removeProduct(ProductModel product) {
    // bool productRemove = false;

    for (var items in allProducts) {
      if (items.containsKey(product.id)) {
        items[product.id]?.remove(product);
        // productRemove = true;
        break;
      }
    }
    setState(() {});
  }

  void mergeMapData(
    List<Map<int, List<ProductModel>>> allProducts,
    List<Map<int, List<ProductModel>>> result,
  ) {
    for (var resultMap in result) {
      resultMap.forEach((key, value) {
        // Check if the key exists in allProducts
        bool found = false;
        for (var allProductMap in allProducts) {
          if (allProductMap.containsKey(key)) {
            found = true;
            // If the value for this key is a map, we recursively call mergeMapData
            if (value is Map && allProductMap[key] is Map) {
              mergeMapData(
                allProductMap[key] as List<Map<int, List<ProductModel>>>,
                value as List<Map<int, List<ProductModel>>>,
              );
            } else {
              // Otherwise, we simply update the key with the new value
              allProductMap[key] = value;
            }
            break;
          }
        }
        // If the key wasn't found in any map, add it
        if (!found) {
          allProducts.add({key: value});
        }
      });
    }
    setState(() {}); // Assuming you want to trigger the UI update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            child: GridView.builder(
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
                        ), // Divider(
                        //   height: 1,
                        //   thickness: 2,
                        //   color: Color(0xFF000000),
                        //   indent: 16,
                        //   endIndent: 16,
                        // ),
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
                                            removeProduct(products[index]);
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
              ))
        ],
      ),
    );
  }
}
