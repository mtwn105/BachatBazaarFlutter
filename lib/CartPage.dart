import 'dart:math';

import 'package:bachatbazaar/BuyPage.dart';
import 'package:bachatbazaar/CartListTile.dart';
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
    Widget _appBarTitle = new Text(
      'cart'.toUpperCase(),
      style: TextStyle(
        letterSpacing: 1.4,
        fontSize: 20.0,
        color: Theme.of(context).primaryColor,
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 32),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 14.0),
                  alignment: Alignment.center,
                  child: _appBarTitle,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text("Empty Cart"),
                                content: new Text(
                                    "It will delete all items from your cart."),
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
              ],
            ),
          ),
          Expanded(
            child: Padding(
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
          ),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: new MaterialButton(
              onPressed: () async {
                if (cart_items != 0) {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new BuyPage(
                            cart_items: cart_items,
                            cart_total_price: cart_total_price)),
                  );
                }
              },
              color: Colors.red,
              child: new Text(
                  "Buy Now ".toUpperCase() + "₹" + cart_total_price.toString(),
                  style: new TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
