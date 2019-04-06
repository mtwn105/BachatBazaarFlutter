import 'dart:collection';

import 'package:bachatbazaar/CartPage.dart';
import 'package:bachatbazaar/MainPage.dart';
import 'package:bachatbazaar/model/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class NegotiatePage extends StatefulWidget {
  final Product product;
  const NegotiatePage({Key key, this.product}) : super(key: key);

  @override
  _NegotiatePageState createState() => _NegotiatePageState(this.product);
}

final FirebaseAuth auth = FirebaseAuth.instance;

class _NegotiatePageState extends State<NegotiatePage> {
  final Product product;
  _NegotiatePageState(this.product);

  bool addToCart = false;

  bool priceEditEnable = true;
  bool yesEnable = true;
  bool noEnable = true;
  bool acceptEnable = true;
  bool declineEnable = true;
  bool addToCartEnable = true;
  bool cancelEnable = true;
  bool third = false;
  bool fourth = false;
  bool fifth = false;
  bool sixth = false;
  bool seven = false;
  bool eight = false;
  bool buydone1 = false;
  bool buydone2 = false;
  bool decline = false;

  final quantityController = TextEditingController();
  final singlePriceController = TextEditingController();
  final productShortDescController = TextEditingController();

  String userId = "";
  String phoneNumber = "";

  Future userDetails() async {
    String uid = await auth.currentUser().then((user) => user.uid);
    DocumentSnapshot userInfo =
        await Firestore.instance.collection('users').document(uid).get();
    setState(() {
      userId = uid;
    });
  }

  @override
  void initState() {
    userDetails();
    singlePriceController.text = "0";
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    quantityController.dispose();
    singlePriceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style =
        TextStyle(color: Theme.of(context).primaryColor, fontSize: 14);

    int actualPrice = (product.productOffer
        ? product.productOfferPrice
        : product.productPrice);
    int method1 =
        (int.parse(singlePriceController.text) + (actualPrice * 0.1).round());
    int method2 = product.productMinPrice;
    int method3 =
        (product.productMinPrice + ((product.productMinPrice) * 0.05).round());
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Negotitation"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: addToCart,
        dismissible: false,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Text(
                        "Do you want to enter negotiations?",
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              new SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16),
                      topLeft: Radius.circular(16)),
                  child: Container(
                    height: 40,
                    width: 200,
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            MaterialButton(
                              onPressed: yesEnable
                                  ? () {
                                      setState(() {
                                        yesEnable = false;
                                        noEnable = false;
                                        third = true;
                                        fourth = true;
                                      });
                                    }
                                  : null,
                              child: Text(
                                "YES",
                                style: new TextStyle(color: Colors.white),
                              ),
                            ),
                            MaterialButton(
                              onPressed: noEnable
                                  ? () {
                                      Navigator.pushReplacement(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new MainPage()),
                                      );
                                    }
                                  : null,
                              child: Text(
                                "NO",
                                style: new TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
              new SizedBox(
                height: 5,
              ),
              third
                  ? Container(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Text(
                              "How much quantities you want to purchase (min " +
                                  product.productMinStock.toString() +
                                  ")",
                              style: new TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              new SizedBox(
                height: 5,
              ),
              fourth
                  ? Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16),
                            topLeft: Radius.circular(16)),
                        child: Container(
                          height: 80,
                          width: 200,
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: TextField(
                                        enabled: !fifth,
                                        keyboardType: TextInputType.number,
                                        obscureText: false,
                                        controller: quantityController,
                                        style: style,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 15.0, 20.0, 15.0),
                                            hintText: "Enter Quantity",
                                            filled: true,
                                            fillColor: Colors.white,
                                            focusedBorder:
                                                new OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32.0),
                                                    borderSide: BorderSide(
                                                        width: 3,
                                                        color: Theme.of(context)
                                                            .accentColor)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        32.0))),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      int quantity =
                                          int.parse(quantityController.text);

                                      if (quantity >= product.productMinStock) {
                                        setState(() {
                                          fifth = true;
                                          sixth = true;
                                        });
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  new Text("Can't Negotiate"),
                                              content: new Text(
                                                  "Purchase at least " +
                                                      product.productMinStock
                                                          .toString() +
                                                      " quantity to enter the negotitation"),
                                              actions: <Widget>[
                                                new FlatButton(
                                                  child: new Text("Close"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                  )
                                ],
                              )),
                        ),
                      ),
                    )
                  : Container(),
              new SizedBox(
                height: 5,
              ),
              fifth
                  ? Container(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Text(
                              "How much you would pay for 1 item (current price: ₹" +
                                  actualPrice.toString() +
                                  ")",
                              style: new TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              new SizedBox(
                height: 5,
              ),
              sixth
                  ? Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16),
                            topLeft: Radius.circular(16)),
                        child: Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width * 0.6,
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 300,
                                      child: TextField(
                                        enabled: priceEditEnable,
                                        keyboardType: TextInputType.number,
                                        obscureText: false,
                                        controller: singlePriceController,
                                        style: style,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 15.0, 20.0, 15.0),
                                            hintText:
                                                "Enter Price of Single Item",
                                            filled: true,
                                            fillColor: Colors.white,
                                            focusedBorder:
                                                new OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32.0),
                                                    borderSide: BorderSide(
                                                        width: 3,
                                                        color: Theme.of(context)
                                                            .accentColor)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        32.0))),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      int enteredPrice =
                                          int.parse(singlePriceController.text);

                                      if (enteredPrice >=
                                          product.productMinPrice) {
                                        setState(() {
                                          priceEditEnable = false;
                                          buydone1 = true;
                                          buydone2 = true;
                                        });
                                      } else {
                                        setState(() {
                                          priceEditEnable = false;
                                          seven = true;
                                          eight = true;
                                        });
                                      }
                                    },
                                  )
                                ],
                              )),
                        ),
                      ),
                    )
                  : Container(),
              new SizedBox(
                height: 5,
              ),
              seven
                  ? Container(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: int.parse(singlePriceController.text) >=
                                    (actualPrice * 2 / 3)
                                ? int.parse(singlePriceController.text) +
                                            ((actualPrice * 0.1).round()) >=
                                        product.productMinPrice
                                    ? new Text(
                                        "That is too low. How about ₹" +
                                            method1.toString(),
                                        style:
                                            new TextStyle(color: Colors.white),
                                      )
                                    : new Text(
                                        "That is too low. Minimum Price would be ₹" +
                                            method2.toString(),
                                        style:
                                            new TextStyle(color: Colors.white),
                                      )
                                : new Text(
                                    "That is too low. Minimum Price would be ₹" +
                                        method3.toString(),
                                    style: new TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              new SizedBox(
                height: 5,
              ),
              eight
                  ? Container(
                      alignment: Alignment.centerRight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16),
                            topLeft: Radius.circular(16)),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.65,
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  MaterialButton(
                                    onPressed: acceptEnable
                                        ? () {
                                            setState(() {
                                              acceptEnable = false;
                                              declineEnable = false;
                                              buydone1 = true;
                                              buydone2 = true;
                                            });
                                          }
                                        : null,
                                    child: Text(
                                      "ACCEPT",
                                      style: new TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: declineEnable
                                        ? () {
                                            acceptEnable = false;
                                            declineEnable = false;
                                            decline = true;
                                          }
                                        : null,
                                    child: Text(
                                      "DECLINE",
                                      style: new TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    )
                  : Container(),
              new SizedBox(
                height: 5,
              ),
              decline
                  ? Container(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Text(
                              "Thanks for your time. Deal couldn't finalized.",
                              style: new TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              new SizedBox(
                height: 5,
              ),
              buydone1
                  ? Container(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: int.parse(singlePriceController.text) <
                                    product.productMinPrice
                                ? int.parse(singlePriceController.text) >=
                                        (actualPrice * 2 / 3)
                                    ? int.parse(singlePriceController.text) +
                                                ((actualPrice * 0.1).round()) >=
                                            product.productMinPrice
                                        ? new Text(
                                            "Congratultions. Deal Done for ₹" +
                                                method1.toString() +
                                                " per item",
                                            style: new TextStyle(
                                                color: Colors.white),
                                          )
                                        : new Text(
                                            "Congratultions. Deal Done for ₹" +
                                                method2.toString() +
                                                " per item",
                                            style: new TextStyle(
                                                color: Colors.white),
                                          )
                                    : new Text(
                                        "Congratultions. Deal Done for ₹" +
                                            method3.toString() +
                                            " per item",
                                        style:
                                            new TextStyle(color: Colors.white),
                                      )
                                : new Text(
                                    "Congratultions. Deal Done for ₹" +
                                        singlePriceController.text +
                                        " per item",
                                    style: new TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              new SizedBox(
                height: 5,
              ),
              buydone1
                  ? Container(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: int.parse(singlePriceController.text) <
                                    product.productMinPrice
                                ? int.parse(singlePriceController.text) >=
                                        (actualPrice * 2 / 3)
                                    ? int.parse(singlePriceController.text) +
                                                ((actualPrice * 0.1).round()) >=
                                            product.productMinPrice
                                        ? new Text(
                                            "Total Price is ₹" +
                                                (int.parse(quantityController
                                                            .text) *
                                                        method1)
                                                    .toString(),
                                            style: new TextStyle(
                                                color: Colors.white),
                                          )
                                        : new Text(
                                            "Total Price is ₹" +
                                                (int.parse(quantityController
                                                            .text) *
                                                        method2)
                                                    .toString(),
                                            style: new TextStyle(
                                                color: Colors.white),
                                          )
                                    : new Text(
                                        "Total Price is ₹" +
                                            (int.parse(quantityController
                                                        .text) *
                                                    method3)
                                                .toString(),
                                        style:
                                            new TextStyle(color: Colors.white),
                                      )
                                : new Text(
                                    "Total Price is ₹" +
                                        (int.parse(quantityController.text) *
                                                int.parse(
                                                    singlePriceController.text))
                                            .toString(),
                                    style: new TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              new SizedBox(
                height: 5,
              ),
              buydone1
                  ? Container(
                      alignment: Alignment.centerRight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16),
                            topLeft: Radius.circular(16)),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.65,
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  MaterialButton(
                                    onPressed: addToCartEnable
                                        ? () async {
                                            setState(() {
                                              addToCart = true;
                                            });

                                            int finalSingleItemPrice = 0;

                                            int.parse(singlePriceController
                                                        .text) <
                                                    product.productMinPrice
                                                ? int.parse(singlePriceController
                                                            .text) >=
                                                        (actualPrice * 2 / 3)
                                                    ? int.parse(singlePriceController
                                                                    .text) +
                                                                ((actualPrice *
                                                                        0.1)
                                                                    .round()) >=
                                                            product
                                                                .productMinPrice
                                                        ? finalSingleItemPrice =
                                                            method1
                                                        : finalSingleItemPrice =
                                                            method2
                                                    : finalSingleItemPrice =
                                                        method3
                                                : finalSingleItemPrice =
                                                    int.parse(
                                                        singlePriceController
                                                            .text);
                                            int quantity = int.parse(
                                                quantityController.text);
                                            int totalPrice =
                                                quantity * finalSingleItemPrice;
                                            Map<String, dynamic> productData =
                                                new HashMap();
                                            productData['product_data'] =
                                                product.toJson();
                                            productData['product_price'] =
                                                finalSingleItemPrice;
                                            productData['product_quantity'] =
                                                quantity;
                                            productData['product_total_price'] =
                                                totalPrice;

                                            DocumentSnapshot user =
                                                await Firestore.instance
                                                    .collection('users')
                                                    .document(userId)
                                                    .get();

                                            int cart_items = user['cart_items'];
                                            int cart_price =
                                                user['cart_total_price'];

                                            print(cart_items);
                                            print(cart_price);

                                            cart_items++;
                                            cart_price += totalPrice;

                                            await Firestore.instance
                                                .collection('users')
                                                .document(userId)
                                                .collection('cart')
                                                .document(
                                                    (cart_items - 1).toString())
                                                .setData(productData);

                                            await Firestore.instance
                                                .collection('users')
                                                .document(userId)
                                                .updateData({
                                              'cart_items': cart_items,
                                              'cart_total_price': cart_price,
                                            });

                                            Navigator.pushReplacement(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new CartPage()),
                                            );

                                            addToCartEnable = false;
                                            cancelEnable = false;
                                            setState(() {
                                              addToCart = false;
                                            });
                                          }
                                        : null,
                                    child: Text(
                                      "ADD TO CART",
                                      style: new TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: cancelEnable
                                        ? () {
                                            addToCartEnable = false;
                                            cancelEnable = false;
                                            decline = true;
                                          }
                                        : null,
                                    child: Text(
                                      "CANCEL",
                                      style: new TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    )
                  : Container(),
              new SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
