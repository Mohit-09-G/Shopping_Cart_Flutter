import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop/database/dbhelper.dart';
import 'package:shop/models/all_products.dart';
import 'package:shop/models/product_model.dart';

final _messageController = TextEditingController();

class AddToCart extends StatefulWidget {
  final List<Map<int, List<ProductModel>>> cartItems;

  const AddToCart({super.key, required this.cartItems});

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  List<Map<int, List<ProductModel>>> newcartItems = [];
  double afterDisc = 0.0;
  double amntDisc = 0.0;
  bool _validate = false;
  String errorMessage = '';
  final _focusNode = FocusNode();

  void removeFromCart(ProductModel product) {
    setState(() {
      widget.cartItems.remove(product);
    });
  }

  List<Map<int, List<ProductModel>>> filterList() {
    final List<Map<int, List<ProductModel>>> newcartItems = [];

    for (var i = 0; i < widget.cartItems.length; i++) {
      if (widget.cartItems[i][i]!.isNotEmpty) {
        newcartItems.add(widget.cartItems[i]);
      }
    }
    return newcartItems;
  }

  addItems(ProductModel product) {
    bool productAdded = false;

    for (var productA in newcartItems) {
      if (productA.containsKey(product.id)) {
        productA[product.id]?.add(product);
        productAdded = true;
        break;
      }
    }
    if (!productAdded) {
      newcartItems.add({
        product.id: [product]
      });
    }
    // setState(() {
    //   newcartItems = filterList();
    //   itemAmount();
    //   applyDiscunt();
    // });
    _updateAllProductsModelInDb();
  }

  void _updateAllProductsModelInDb() async {
    try {
      AllProductsModel allProductsModel =
          AllProductsModel(productGroups: newcartItems);

      await DatabaseHelper.instance.insertAllProducts(allProductsModel);
      allProductsModel = await DatabaseHelper.instance.queryAllProductsModel();
      setState(() {
        newcartItems = allProductsModel.productGroups;
        itemAmount();
        applyDiscunt();
        print(newcartItems);
      });
    } catch (e) {
      print("Error updating AllProductsModel in DB: $e");
    }
  }

  applyDiscunt() {
    int dicountPrice = 20;
    String input = _messageController.text.trim();

    if (input.toLowerCase() == 'mohit') {
      double discountRpice = (amountOne * dicountPrice) / 100;

      double afterApplyingDiscount = amountOne - discountRpice;
      setState(() {
        _validate = false;
        amntDisc = discountRpice;

        afterDisc = afterApplyingDiscount;
      });
    } else if (input.isEmpty) {
      setState(() {
        _validate = true;
        amntDisc = 0.0;
        errorMessage = 'Feild cannot be empty!';
        afterDisc = amountOne;
      });
    } else {
      setState(() {
        _validate = true;
        amntDisc = 0.0;

        errorMessage = 'Invalid Code';
        afterDisc = amountOne;
      });
    }
  }

  removeItems(ProductModel product) async {
    for (var Items in newcartItems) {
      if (Items.containsKey(product.id)) {
        List<ProductModel> productList = Items[product.id] ?? [];

        productList.removeAt(productList.length - 1);

        Items[product.id] = productList;

        break;
      }
    }
    AllProductsModel allProductsModel1 =
        AllProductsModel(productGroups: newcartItems);
    await DatabaseHelper.instance.deleteProductFromGroup(allProductsModel1);

    AllProductsModel allProductsModel =
        await DatabaseHelper.instance.queryAllProductsModel();

    setState(() {
      // newcartItems = filterList();
      newcartItems = allProductsModel.productGroups;
      itemAmount();
      applyDiscunt();
    });
  }

  @override
  void initState() {
    newcartItems = filterList();
    itemAmount();
    super.initState();
  }

  double amountOne = 0.0;

  void itemAmount() {
    double itemPrice = 0;

    // if (newcartItems.isEmpty) {
    //   setState(() {
    //     amountOne = 0;
    //   });
    //   return 0;
    // }

    for (Map<int, List<ProductModel>> cartItem in newcartItems) {
      cartItem.forEach((key, productList) {
        for (ProductModel product in productList) {
          String price = product.productPrice
              .replaceAll('\$', '')
              .replaceAll('"', '')
              .trim();
          itemPrice += double.parse(price);
        }
      });
    }

    setState(() {
      amountOne = itemPrice;
      afterDisc = amountOne;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, newcartItems);
              },
              icon: Icon(Icons.back_hand)),
          backgroundColor: Colors.white,
          title: Text(
            "Cart",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500, color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Container(
          child: widget.cartItems.isEmpty
              ? Center(
                  child: Text(
                    "Your cart is empty!",
                    style:
                        GoogleFonts.poppins(fontSize: 18, color: Colors.black),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: newcartItems.length,
                        itemBuilder: (context, index) {
                          final product = newcartItems[index].values.first;
                          final count = newcartItems[index].values.first.length;

                          // return Container();
                          return Dismissible(
                            key: Key(product[0].id.toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              // removeFromCart(product);
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: ListTile(
                                leading: Image.asset(product[0].productImage,
                                    width: 50, height: 50),
                                title: Text(
                                  product[0].productName,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600),
                                ),
                                // subtitle: Text(
                                //   "${product.productQuantity} - ${product.productPrice}",
                                //   style: GoogleFonts.poppins(),
                                // ),
                                trailing: GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          removeItems(product[index]);
                                        },
                                        child: Image.asset(
                                          "assets/icons/minus.png",
                                          height: 15,
                                          width: 15,
                                        ),
                                      ),
                                      Text(
                                        count.toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0XFF000000),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          addItems(product[index]);
                                        },
                                        child: Image.asset(
                                          "assets/icons/plus.png",
                                          height: 15,
                                          width: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // FittedBox(
                    //   child: Container(
                    //     height: 100,
                    //     width: 10,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color: Color(0xFF868889)),
                    //   ),
                    // )

                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10.0))),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Subtotal",
                                  style: TextStyle(
                                      color: Color(0xFF868889),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      amountOne.toString(),
                                      style: TextStyle(
                                          color: Color(0xFF868889),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      "Apply Coupon",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF868889)),
                                    )),
                                    Flexible(
                                      child: TextField(
                                        focusNode: _focusNode,
                                        controller: _messageController,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            errorText:
                                                _validate ? errorMessage : null,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                            hintText: "Enter Code",
                                            hintStyle: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF000000)),
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  applyDiscunt();
                                                },
                                                icon: Icon(
                                                    Icons.attach_money_sharp))),
                                      ),
                                    ),
                                  ],
                                ),
                                // Container(
                                //   height: 1,
                                //   color: Color(0xFF868889),
                                // ),
                                Container(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Dicount Amount ",
                                      style: TextStyle(
                                          color: Color(0xFF868889),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      amntDisc.toString(),
                                      style: TextStyle(
                                          color: Color(0xFF868889),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 0.5,
                                    color: Color(0xFFF4F5F9),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Toatal Amount ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      afterDisc.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Navigate back to the product list
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Check Out",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
