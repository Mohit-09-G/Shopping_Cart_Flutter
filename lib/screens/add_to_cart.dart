import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop/models/product_model.dart';

class AddToCart extends StatefulWidget {
  final List<Map<int, List<ProductModel>>> cartItems;

  const AddToCart({super.key, required this.cartItems});

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  List<Map<int, List<ProductModel>>> newcartItems = [];
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
    setState(() {});
  }

  removeItems(ProductModel product) {
    for (var Items in newcartItems) {
      if (Items.containsKey(product.id)) {
        Items[product.id]?.remove(product);
        break;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    newcartItems = filterList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: widget.cartItems.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty!",
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.black),
              ),
            )
          : ListView.builder(
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Image.asset(product[0].productImage,
                          width: 50, height: 50),
                      title: Text(
                        product[0].productName,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "Check out",
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
