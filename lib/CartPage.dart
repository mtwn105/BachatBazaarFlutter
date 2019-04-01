import 'dart:math';

import 'package:bachatbazaar/BuyPage.dart';
import 'package:bachatbazaar/CartListTile.dart';
import 'package:bachatbazaar/model/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

final FirebaseAuth auth = FirebaseAuth.instance;

class _CartPageState extends State<CartPage> {
  String userName = "";
  String userId = "";
  String email = "";
  String phoneNumber = "";
  int cart_items = 0;
  int cart_total_price = 0;

  Future userDetails() async {
    String uid = await auth.currentUser().then((user) => user.uid);
    DocumentSnapshot userInfo =
        await Firestore.instance.collection('users').document(uid).get();
    setState(() {
      userName = userInfo['name'];
      userId = uid;
      email = userInfo['email'];
      phoneNumber = userInfo['phone'];
      cart_items = userInfo['cart_items'];
      cart_total_price = userInfo['cart_total_price'];
      print(userName);
    });
  }

  @override
  void initState() {
    userDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Cart"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: new Text("Empty Cart"),
                      content:
                          new Text("It will delete all items from your cart."),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text("DELETE"),
                          onPressed: () async {
                            for (var i = 0; i < cart_items; i++) {
                              await Firestore.instance
                                  .collection('users')
                                  .document(userId)
                                  .collection('cart')
                                  .document(i.toString())
                                  .delete();
                            }

                            setState(() {
                              cart_items = 0;
                              cart_total_price = 0;
                            });

                            await Firestore.instance
                                .collection('users')
                                .document(userId)
                                .updateData({
                              'cart_items': cart_items,
                              'cart_total_price': cart_total_price,
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        new FlatButton(
                          child: new Text("CLOSE"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(userId)
                  .collection('cart')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Center(child: new Text("Loading..."));
                  default:
                    if (snapshot.data.documents.length == 0) {
                      return new Center(child: new Text("Cart is empty."));
                    } else {
                      return new ListView(
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return buildCartListTile(context, document);
                        }).toList(),
                      );
                    }
                }
              },
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height - 128),
            child: new SizedBox.expand(
              child: new MaterialButton(
                onPressed: () async {
                  if (cart_items != 0) {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              new BuyPage(cart_items:cart_items, cart_total_price: cart_total_price)),
                    );

                    /*       final String rand1 = "${new Random().nextInt(100000)}";
                  final String rand2 = "${new Random().nextInt(100000)}";
                  final String rand3 = "${new Random().nextInt(100000)}";
                  final String rand4 = "${new Random().nextInt(100000)}";
                  final String orderId = rand1 + rand2 + rand3 + rand4;

                  DocumentSnapshot seller = await Firestore.instance
                      .collection('users')
                      .document(userId)
                      .collection('cart')
                      .document('0')
                      .get();

                  Product product = Product.fromJson(seller['product_data']);
                  String sellerName = product.productSellerName;

                  await Firestore.instance
                      .collection('users')
                      .document(userId)
                      .collection('orders')
                      .document(orderId)
                      .setData({
                    'order_id': orderId,
                    'order_seller_name': sellerName,
                    'order_items': cart_items,
                    'order_total_price': cart_total_price,
                    'order_address': "",
                    'order_pincode': "",
                    'order_status': "",
                    'order_city': "",
                    'order_state': "",
                  });
                  */
                  }
                },
                color: Colors.red,
                child: new Text("Buy Now " + "₹" + cart_total_price.toString(),
                    style: new TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
